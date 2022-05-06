//
//  AuthorizationResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/3.
//

import Foundation

public struct AuthorizationResponse {
    
    public let authorizationID: String
    public let authorizationCode: String
    public let scopes: [String]
    public let codeID: String
    public let createdAt: String
    public let accessedAt: String
    public let app: App
    
}

extension AuthorizationResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case authorizationID = "authorization_id"
        case authorizationCode = "authorization_code"
        case scopes
        case codeID = "code_id"
        case createdAt = "created_at"
        case accessedAt = "accessed_at"
        case app
    }
    
}
