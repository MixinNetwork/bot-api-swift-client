//
//  CollectibleWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class CollectibleWorker: Worker {
    
    public func cancel(requestId: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: "/collectibles/requests/\(requestId)/cancel", completion: completion)
    }
    
    public func sign(requestId: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { pin in
            self.post(path: "/collectibles/requests/\(requestId)/sign",
                      parameters: ["pin_base64": pin],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func unlock(requestId: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { pin in
            self.post(path: "/collectibles/requests/\(requestId)/unlock",
                      parameters: ["pin_base64": pin],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func token(tokenId: String) -> API.Result<CollectibleToken> {
        get(path: "/collectibles/tokens/\(tokenId)")
    }
    
}
