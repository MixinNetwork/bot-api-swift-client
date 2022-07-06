//
//  CollectibleWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class CollectibleWorker<Error: ServerError & Decodable>: Worker<Error> {
    
    public func cancel(requestID: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: "/collectibles/requests/\(requestID)/cancel", completion: completion)
    }
    
    public func sign(requestID: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { pin in
            self.post(path: "/collectibles/requests/\(requestID)/sign",
                      parameters: ["pin_base64": pin],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func unlock(requestID: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { pin in
            self.post(path: "/collectibles/requests/\(requestID)/unlock",
                      parameters: ["pin_base64": pin],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func token(tokenID: String) -> API.Result<CollectibleToken> {
        get(path: "/collectibles/tokens/\(tokenID)")
    }
    
}
