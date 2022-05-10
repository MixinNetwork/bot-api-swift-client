//
//  MultisigWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class MultisigWorker: Worker {
    
    public func cancel(requestID: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: "/multisigs/\(requestID)/cancel", completion: completion)
    }
    
    public func sign(requestID: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { encryptedPIN in
            self.post(path: "/multisigs/\(requestID)/sign",
                      parameters: ["pin_base64": encryptedPIN],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func unlock(requestID: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { encryptedPIN in
            self.post(path: "/multisigs/\(requestID)/unlock",
                      parameters: ["pin_base64": encryptedPIN],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
}
