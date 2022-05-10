//
//  UserSession.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct UserSession {
    
    public let userID: String
    public let sessionID: String
    public let platform: String?
    public let publicKey: String?
    
}

extension UserSession: Codable {
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case sessionID = "session_id"
        case platform
        case publicKey = "public_key"
    }
    
}
