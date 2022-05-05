//
//  AuthorizationResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/3.
//

import Foundation

public struct AuthorizationResponse: Decodable {
    
    public let authorizationID: String
    public let authorizationCode: String
    public let scopes: [String]
    public let codeID: String
    public let createdAt: String
    public let accessedAt: String
    public let app: App
    
}
