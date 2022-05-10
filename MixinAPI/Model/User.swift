//
//  User.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public class User: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case fullName = "full_name"
        case biography = "biography"
        case identityNumber = "identity_number"
        case avatarURL = "avatar_url"
        case phone
        case isVerified = "is_verified"
        case muteUntil = "mute_until"
        case appID = "app_id"
        case createdAt = "created_at"
        case relationship
        case isScam = "is_scam"
    }
    
    public let userID: String
    public let fullName: String?
    public let biography: String?
    public let identityNumber: String
    public let avatarURL: String?
    public let phone: String?
    public let isVerified: Bool
    public let muteUntil: String?
    public let appID: String?
    public let createdAt: String?
    public let relationship: String
    public let isScam: Bool
    
    init(userID: String, fullName: String?, biography: String?, identityNumber: String, avatarURL: String?, phone: String? = nil, isVerified: Bool, muteUntil: String? = nil, appID: String? = nil, createdAt: String?, relationship: String, isScam: Bool) {
        self.userID = userID
        self.fullName = fullName
        self.biography = biography
        self.identityNumber = identityNumber
        self.avatarURL = avatarURL
        self.phone = phone
        self.isVerified = isVerified
        self.muteUntil = muteUntil
        self.appID = appID
        self.createdAt = createdAt
        self.relationship = relationship
        self.isScam = isScam
    }
    
}
