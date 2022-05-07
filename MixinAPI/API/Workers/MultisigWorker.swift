//
//  MultisigWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class MultisigWorker: Worker {
    
    public func cancel(requestId: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: "/multisigs/\(requestId)/cancel", completion: completion)
    }
    
    public func sign(requestId: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { encryptedPin in
            self.post(path: "/multisigs/\(requestId)/sign",
                      parameters: ["pin_base64": encryptedPin],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func unlock(requestId: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { encryptedPin in
            self.post(path: "/multisigs/\(requestId)/unlock",
                      parameters: ["pin_base64": encryptedPin],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
}
