//
//  API+Session.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/1.
//

import Foundation

extension API {
    
    public class Session {
        
        let host: Host
        let client: Client
        let analytic: Analytic?
        let urlSession: URLSession
        let requestHeaders: [String: String]
        let serializationQueue = DispatchQueue(label: "one.mixin.network.api.session.serialization")
        
        public init(hostStorage: HostStorage, client: Client, analytic: Analytic?) {
            self.host = Host(storage: hostStorage)
            self.client = client
            self.analytic = analytic
            
            var headers = [
                "Content-Type": "application/json",
                "Accept-Language": client.acceptLanguage,
                "User-Agent": client.userAgent,
            ]
            if let id = client.deviceId {
                headers["Mixin-Device-Id"] = id
            }
            self.requestHeaders = headers
            
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 10
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            let redirectionBlocker = RedirectionBlocker()
            self.urlSession = URLSession(configuration: config,
                                         delegate: redirectionBlocker,
                                         delegateQueue: nil)
        }
        
        func encryptPIN<Response>(_ pin: String, onFailure: @escaping (API.Result<Response>) -> Void, onSuccess: @escaping (String) -> Void) {
            onFailure(.failure(TransportError.unauthorizedSession))
        }
        
    }
    
}
