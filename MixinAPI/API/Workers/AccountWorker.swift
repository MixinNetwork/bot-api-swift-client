//
//  AccountWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/5.
//

import Foundation

public class AccountWorker: Worker {
    
    public enum LogCategory {
        case incorrectPIN
        case all
    }
    
    private enum Path {
        static let me = "/me"
    }
    
    public func me(completion: @escaping (API.Result<Account>) -> Void) {
        get(path: Path.me, completion: completion)
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
    
    public func verify(pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { pin in
            self.post(path: "/pin/verify",
                      parameters: ["pin_base64": pin],
                      completion: completion)
        }
    }
    
    public func updatePIN(old: String?, new: String, completion: @escaping (API.Result<Account>) -> Void) {
        guard let encryptor = (session as? API.AuthenticatedSession)?.pinEncryptor else {
            completion(.failure(TransportError.unauthorizedSession))
            return
        }
        
        var param: [String: String] = [:]
        
        func performUpdate() {
            encryptor.encrypt(pin: new, onFailure: completion) { encryptedPIN in
                param["pin_base64"] = encryptedPIN
                self.post(path: "/pin/update",
                          parameters: param,
                          options: .disableRetryOnRequestSigningTimeout,
                          completion: completion)
            }
        }
        
        if let old = old {
            encryptor.encrypt(pin: old, onFailure: completion) { encryptedPIN in
                param["old_pin_base64"] = encryptedPIN
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
        case .incorrectPIN:
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
    
}
