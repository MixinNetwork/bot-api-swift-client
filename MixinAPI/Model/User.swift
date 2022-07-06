//
//  User.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/5.
//

import Foundation

public struct User {
    
    public let userID: String
    public let sessionID: String
    public let hasPIN: Bool
    public let pinToken: String
    public let fullName: String
    public let biography: String
    public let avatarURL: String
    public let createdAt: String
    
}

extension User: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case sessionID = "session_id"
        case hasPIN = "has_pin"
        case pinToken = "pin_token_base64"
        case fullName = "full_name"
        case biography
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
    }
    
}
