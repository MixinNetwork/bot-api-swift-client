//
//  Worker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/28.
//

import Foundation

public class Worker {
    
    struct Options: OptionSet {
        
        static let authIndependent = Options(rawValue: 1 << 0)
        static let disableRetryOnRequestSigningTimeout = Options(rawValue: 1 << 1)
        
        let rawValue: UInt
        
        init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
    let session: API.Session
    
    private let requestIDField = "x-request-id"
    
    init(session: API.Session) {
        self.session = session
    }
    
    @discardableResult
    func get<Response>(
        path: String,
        options: Options = [],
        queue: DispatchQueue = .main,
        completion: @escaping (API.Result<Response>) -> Void
    ) -> Request {
        request(method: .get,
                path: path,
                body: { nil },
                options: options,
                queue: queue,
                completion: completion)
    }
    
    @discardableResult
    func post<Response>(
        path: String,
        parameters: [String: Any]? = nil,
        options: Options = [],
        queue: DispatchQueue = .main,
        completion: @escaping (API.Result<Response>) -> Void
    ) -> Request {
        request(method: .post, path: path, body: {
            if let parameters = parameters {
                return try JSONSerialization.data(withJSONObject: parameters, options: [])
            } else {
                return nil
            }
        }, options: options, queue: queue, completion: completion)
    }
    
    @discardableResult
    func post<Parameters: Encodable, Response>(
        path: String,
        parameters: Parameters? = nil,
        options: Options = [],
        queue: DispatchQueue = .main,
        completion: @escaping (API.Result<Response>) -> Void
    ) -> Request {
        request(method: .post, path: path, body: {
            if let parameters = parameters {
                return try JSONEncoder.default.encode(parameters)
            } else {
                return nil
            }
        }, options: options, queue: queue, completion: completion)
    }
    
    func get<Response>(
        path: String,
        options: Options = []
    ) -> API.Result<Response> {
        request(method: .get,
                path: path,
                body: { nil },
                options: options)
    }
    
    func post<Response>(
        path: String,
        parameters: [String: Any]? = nil,
        options: Options = []
    ) -> API.Result<Response> {
        request(method: .post, path: path, body: {
            if let parameters = parameters {
                return try JSONSerialization.data(withJSONObject: parameters, options: [])
            } else {
                return nil
            }
        }, options: options)
    }
    
    func post<Parameters: Encodable, Response>(
        path: String,
        parameters: Parameters? = nil,
        options: Options = []
    ) -> API.Result<Response> {
        request(method: .post, path: path, body: {
            if let parameters = parameters {
                return try JSONEncoder.default.encode(parameters)
            } else {
                return nil
            }
        }, options: options)
    }
    
}

extension Worker {
    
    private struct RawResponse<Response: Decodable>: Decodable {
        let data: Response?
        let error: RemoteError?
    }
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    private enum UnauthorizedReason {
        
        case clockSkew
        case requestSigningTimedOut
        
        init?(requestSigningDate: Date, response: HTTPURLResponse) {
            let serverTime: Date = {
                let xServerTime: TimeInterval
                if let value = response.value(forHTTPHeaderField: "x-server-time") {
                    xServerTime = TimeInterval(value) ?? 0
                } else {
                    xServerTime = 0
                }
                let serverTimeIntervalSince1970 = xServerTime / TimeInterval(NSEC_PER_SEC)
                return Date(timeIntervalSince1970: serverTimeIntervalSince1970)
            }()
            if abs(requestSigningDate.timeIntervalSinceNow) > .minute {
                self = .requestSigningTimedOut
            } else if abs(serverTime.timeIntervalSinceNow) > 5 * .minute {
                self = .clockSkew
            } else {
                return nil
            }
        }
        
    }
    
    private static func shouldToggleServer(for error: Swift.Error) -> Bool {
        guard let error = error as? URLError else {
            return false
        }
        let codes: [URLError.Code] = [
            .timedOut,
            .cannotConnectToHost,
            .cannotFindHost,
            .dnsLookupFailed,
            .resourceUnavailable,
            .secureConnectionFailed
        ]
        return codes.contains(error.code)
    }
    
    private func request<Response>(
        method: HTTPMethod,
        path: String,
        body makeBody: @escaping () throws -> Data?,
        options: Options = []
    ) -> API.Result<Response> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: API.Result<Response> = .failure(TransportError.syncRequestFailed)
        
        request(method: method, path: path, body: makeBody) { (theResult: API.Result<Response>) in
            result = theResult
            semaphore.signal()
        }
        semaphore.wait()
        
        switch result {
        case let .failure(TransportError.taskFailed(error)):
            if let error = error as? URLError, error.code == .timedOut {
                fallthrough
            }
        case .failure(TransportError.clockSkewDetected), .failure(TransportError.requestSigningTimeout):
            session.analytic?.log(level: .error, category: "Worker", message: "Sync request timed out with: \(result)", userInfo: nil)
        default:
            break
        }
        return result
    }
    
    @discardableResult
    private func request<Response>(
        request: Request = Request(),
        method: HTTPMethod,
        path: String,
        body makeBody: @escaping () throws -> Data?,
        options: Options = [],
        queue: DispatchQueue = .main,
        completion: @escaping (API.Result<Response>) -> Void
    ) -> Request {
        session.serializationQueue.async {
            let host = self.session.host.http()
            let urlString = "https://" + host.value + path
            guard let url = URL(string: urlString) else {
                queue.async {
                    completion(.failure(TransportError.invalidPath(path)))
                }
                return
            }
            
            let requestId = UUID().uuidString.lowercased()
            let signingDate = Date()
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.allHTTPHeaderFields = self.session.requestHeaders
            urlRequest.setValue(requestId, forHTTPHeaderField: self.requestIDField)
            do {
                urlRequest.httpBody = try makeBody()
                if let session = self.session as? API.AuthenticatedSession {
                    let token = try session.authorizationToken(request: urlRequest, id: requestId, date: signingDate)
                    urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
                }
            } catch {
                queue.async {
                    completion(.failure(TransportError.buildURLRequest(error)))
                }
                return
            }
            
            let task = self.session.urlSession.dataTask(with: urlRequest) { data, response, error in
                self.taskDidComplete(request: request,
                                     method: method,
                                     path: path,
                                     body: urlRequest.httpBody,
                                     options: options,
                                     queue: queue,
                                     completion: completion,
                                     hostIndex: host.index,
                                     requestId: requestId,
                                     requestSigningDate: Date(),
                                     data: data,
                                     response: response,
                                     error: error)
            }
            if request.setTask(task) {
                task.resume()
            } else {
                queue.async {
                    completion(.failure(TransportError.cancelled))
                }
            }
        }
        return request
    }
    
    private func taskDidComplete<Response>(
        request: Request,
        method: HTTPMethod,
        path: String,
        body: Data?,
        options: Options = [],
        queue: DispatchQueue,
        completion: @escaping (API.Result<Response>) -> Void,
        hostIndex: Int,
        requestId: String,
        requestSigningDate: Date,
        data: Data?,
        response: URLResponse?,
        error: Swift.Error?
    ) {
        guard let response = response as? HTTPURLResponse else {
            queue.async {
                completion(.failure(TransportError.invalidResponse(response)))
            }
            return
        }
        guard (200...299).contains(response.statusCode) else {
            self.session.host.toggle(from: hostIndex)
            queue.async {
                completion(.failure(TransportError.invalidStatusCode(response.statusCode)))
            }
            return
        }
        if let error = error {
            let logMessage = "Request path: \(path), id: \(requestId), failed with error: \(error)"
            self.session.analytic?.log(level: .error, category: "Worker", message: logMessage, userInfo: nil)
            if Self.shouldToggleServer(for: error) {
                self.session.host.toggle(from: hostIndex)
            }
            queue.async {
                completion(.failure(TransportError.taskFailed(error)))
            }
        } else if let data = data {
            let responseRequestId = response.value(forHTTPHeaderField: requestIDField)
            guard requestId == responseRequestId else {
                let userInfo: [String : Any] = [
                    "path": path,
                    "id": requestId,
                    "header": response.allHeaderFields,
                ]
                session.analytic?.log(level: .error, category: "Worker", message: "Mismatched request id", userInfo: userInfo)
                completion(.failure(TransportError.mismatchedRequestID))
                return
            }
            do {
                let rawResponse = try JSONDecoder.default.decode(RawResponse<Response>.self, from: data)
                if let data = rawResponse.data {
                    completion(.success(data))
                } else if case .unauthorized = rawResponse.error {
                    let reason = UnauthorizedReason(requestSigningDate: requestSigningDate, response: response)
                    switch reason {
                    case .clockSkew:
                        DispatchQueue.main.sync {
                            NotificationCenter.default.post(name: API.clockSkewDetectedNotification, object: self)
                        }
                        completion(.failure(TransportError.clockSkewDetected))
                    case .requestSigningTimedOut:
                        let info: [String: Any] = [
                            "interval": requestSigningDate.timeIntervalSinceNow,
                            "path": path,
                        ]
                        session.analytic?.log(level: .warning, category: "Worker", message: "Request signing timeout", userInfo: info)
                        if !options.contains(.disableRetryOnRequestSigningTimeout) {
                            self.request(request: request,
                                         method: method,
                                         path: path,
                                         body: { body },
                                         options: options,
                                         queue: queue,
                                         completion: completion)
                        } else {
                            completion(.failure(TransportError.requestSigningTimeout))
                        }
                    case .none:
                        session.analytic?.report(error: RemoteError.unauthorized)
                        DispatchQueue.main.sync {
                            NotificationCenter.default.post(name: API.unauthorizedNotification, object: self)
                        }
                        completion(.failure(RemoteError.unauthorized))
                    }
                } else if let error = rawResponse.error {
                    completion(.failure(error))
                } else {
                    let response = try JSONDecoder.default.decode(Response.self, from: data)
                    completion(.success(response))
                }
            } catch {
                if let analytic = session.analytic {
                    analytic.report(error: error)
                    analytic.log(level: .error,
                                 category: "Worker",
                                 message: "Failed to decode response: \(error)",
                                 userInfo: nil)
                }
                completion(.failure(TransportError.invalidJSON(error)))
            }
        } else {
            queue.async {
                completion(.failure(TransportError.noData(response)))
            }
        }
    }
    
}
