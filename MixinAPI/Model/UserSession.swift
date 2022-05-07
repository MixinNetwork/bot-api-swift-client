//
//  UserSession.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct UserSession {
    
    public let userId: String
    public let sessionId: String
    public let platform: String?
    public let publicKey: String?
    
}

extension UserSession: Codable {
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case sessionId = "session_id"
        case platform
        case publicKey = "public_key"
    }
    
}
