//
//  AccountWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/5.
//

import UIKit

public final class AccountWorker: Worker {
    
    public enum LogCategory {
        case incorrectPin
        case all
    }
    
    public enum CaptchaToken {
        case reCaptcha(String)
        case hCaptcha(String)
    }
    
    public enum VoIPToken {
        
        case token(String)
        case remove
        
        var value: String {
            switch self {
            case .token(let value):
                return value
            case .remove:
                return "REMOVE"
            }
        }
        
    }
    
    private enum Path {
        
        static let me = "/me"
        static let verifications = "/verifications"
        
        static func verifications(id: String) -> String {
            return "/verifications/\(id)"
        }
        
    }
    
    public func me(completion: @escaping (API.Result<Account>) -> Void) {
        get(path: Path.me, completion: completion)
    }
    
    @discardableResult
    public func sendCode(
        to phoneNumber: String,
        captchaToken: CaptchaToken?,
        purpose: VerificationPurpose,
        completion: @escaping (API.Result<VerificationResponse>) -> Void
    ) -> Request? {
        var param = [
            "phone": phoneNumber,
            "purpose": purpose.rawValue
        ]
        switch captchaToken {
        case let .reCaptcha(token):
            param["g_recaptcha_response"] = token
        case let .hCaptcha(token):
            param["hcaptcha_response"] = token
        case .none:
            break
        }
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            param["package_name"] = bundleIdentifier
        }
        return post(path: Path.verifications,
                    parameters: param,
                    options: .authIndependent,
                    completion: completion)
    }
    
    public func login(
        verificationId: String,
        accountRequest: AccountRequest,
        completion: @escaping (API.Result<Account>) -> Void
    ) {
        post(path: Path.verifications(id: verificationId),
             parameters: accountRequest,
             options: .authIndependent,
             completion: completion)
    }
    
    public func changePhoneNumber(verificationId: String, code: String, pin: String, completion: @escaping (API.Result<Account>) -> Void) {
        guard let encryptor = (session as? API.AuthenticatedSession)?.pinEncryptor else {
            completion(.failure(.local(.unauthorizedSession)))
            return
        }
        encryptor.encrypt(pin: pin, onFailure: completion) { (encryptedPin) in
            let request = AccountRequest.phone(code: code,
                                               pin: encryptedPin,
                                               client: self.session.client)
            self.post(path: Path.verifications(id: verificationId),
                      parameters: request,
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func update(fullName: String? = nil, biography: String? = nil, avatarBase64: String? = nil, completion: @escaping (API.Result<Account>) -> Void) {
        guard fullName != nil || avatarBase64 != nil || biography != nil else {
            assertionFailure("Nothing to update")
            return
        }
        var param: [String: String] = [:]
        if let fullName = fullName {
            param["full_name"] = fullName
        }
        if let biography = biography {
            param["biography"] = biography
        }
        if let avatarBase64 = avatarBase64 {
            param["avatar_base64"] = avatarBase64
        }
        post(path: Path.me, parameters: param, completion: completion)
    }
    
    public func updateSession(deviceToken: String? = nil, voipToken: VoIPToken? = nil, deviceCheckToken: String? = nil) {
        let sessionRequest = SessionRequest(client: session.client,
                                            notificationToken: deviceToken,
                                            voipToken: voipToken?.value,
                                            deviceCheckToken: deviceCheckToken)
        post(path: "/session", parameters: sessionRequest) { (result: API.Result<Account>) in
            
        }
    }
    
    public func update(sessionSecret: String) -> API.Result<SessionSecretUpdateResponse> {
        post(path: "/session/secret", parameters: ["session_secret": sessionSecret])
    }
    
    public func preferences(preferenceRequest: UserPreferenceRequest, completion: @escaping (API.Result<Account>) -> Void) {
        post(path: "/me/preferences", parameters: preferenceRequest, completion: completion)
    }
    
    public func verify(pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        guard let encryptor = (session as? API.AuthenticatedSession)?.pinEncryptor else {
            completion(.failure(.local(.unauthorizedSession)))
            return
        }
        encryptor.encrypt(pin: pin, onFailure: completion) { (encryptedPin) in
            self.post(path: "/pin/verify",
                      parameters: ["pin_base64": encryptedPin],
                      completion: completion)
        }
    }
    
    public func updatePin(old: String?, new: String, completion: @escaping (API.Result<Account>) -> Void) {
        guard let encryptor = (session as? API.AuthenticatedSession)?.pinEncryptor else {
            completion(.failure(.local(.unauthorizedSession)))
            return
        }
        
        var param: [String: String] = [:]
        
        func performUpdate() {
            encryptor.encrypt(pin: new, onFailure: completion) { encryptedPin in
                param["pin_base64"] = encryptedPin
                self.post(path: "/pin/update",
                          parameters: param,
                          options: .disableRetryOnRequestSigningTimeout,
                          completion: completion)
            }
        }
        
        if let old = old {
            encryptor.encrypt(pin: old, onFailure: completion) { encryptedPin in
                param["old_pin_base64"] = encryptedPin
                performUpdate()
            }
        } else {
            performUpdate()
        }
    }
    
    public func logs(offset: String? = nil, category: LogCategory, limit: Int? = nil, completion: @escaping (API.Result<[LogResponse]>) -> Void) {
        var params: [String] = []
        if let offset = offset {
            params.append("offset=\(offset)")
        }
        switch category {
        case .incorrectPin:
            params.append("category=PIN_INCORRECT")
        case .all:
            break
        }
        if let limit = limit {
            params.append("limit=\(limit)")
        }
        
        var path = "/logs"
        if !params.isEmpty {
            let query = "?" + params.joined(separator: "&")
            path.append(contentsOf: query)
        }
        
        get(path: path, completion: completion)
    }
    
    public func logoutSession(sessionID: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: "/logout", parameters: ["session_id": sessionID], completion: completion)
    }
    
    public func deactiveVerification(verificationId: String, code: String, completion: @escaping (API.Result<Empty>) -> Void) {
        let parameters = [
            "code": code,
            "purpose": VerificationPurpose.deactivated.rawValue
        ]
        post(path: Path.verifications(id: verificationId),
             parameters: parameters,
             options: .disableRetryOnRequestSigningTimeout,
             completion: completion)
    }
    
    public func deactiveAccount(pin: String, verificationID: String, completion: @escaping (API.Result<Empty>) -> Void) {
        guard let encryptor = (session as? API.AuthenticatedSession)?.pinEncryptor else {
            completion(.failure(.local(.unauthorizedSession)))
            return
        }
        encryptor.encrypt(pin: pin, onFailure: completion) { (encryptedPin) in
            let parameters = ["pin_base64": encryptedPin, "verification_id": verificationID]
            self.post(path: "/me/deactivate",
                      parameters: parameters,
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
}
