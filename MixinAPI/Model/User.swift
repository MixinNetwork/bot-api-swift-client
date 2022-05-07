//
//  User.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public class User: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case fullName = "full_name"
        case biography = "biography"
        case identityNumber = "identity_number"
        case avatarUrl = "avatar_url"
        case phone
        case isVerified = "is_verified"
        case muteUntil = "mute_until"
        case appId = "app_id"
        case createdAt = "created_at"
        case relationship
        case isScam = "is_scam"
    }
    
    public let userId: String
    public let fullName: String?
    public let biography: String?
    public let identityNumber: String
    public let avatarUrl: String?
    public let phone: String?
    public let isVerified: Bool
    public let muteUntil: String?
    public let appId: String?
    public let createdAt: String?
    public let relationship: String
    public let isScam: Bool
    
    init(userId: String, fullName: String?, biography: String?, identityNumber: String, avatarUrl: String?, phone: String? = nil, isVerified: Bool, muteUntil: String? = nil, appId: String? = nil, createdAt: String?, relationship: String, isScam: Bool) {
        self.userId = userId
        self.fullName = fullName
        self.biography = biography
        self.identityNumber = identityNumber
        self.avatarUrl = avatarUrl
        self.phone = phone
        self.isVerified = isVerified
        self.muteUntil = muteUntil
        self.appId = appId
        self.createdAt = createdAt
        self.relationship = relationship
        self.isScam = isScam
    }
    
}
