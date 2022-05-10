//
//  AuthorizeWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/3.
//

import Foundation

public final class AuthorizeWorker: Worker {
    
    public func authorizations(completion: @escaping (API.Result<[AuthorizationResponse]>) -> Void) {
        get(path: "/authorizations", completion: completion)
    }
    
    public func cancel(clientID: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: "/oauth/cancel",
             parameters: ["client_id": clientID],
             completion: completion)
    }
    
    public func authorize(id: String, scopes: [String], completion: @escaping (API.Result<AuthorizationResponse>) -> Void) {
        post(path: "/oauth/authorize",
             parameters: ["authorization_id": id, "scopes": scopes],
             completion: completion)
    }
    
}
