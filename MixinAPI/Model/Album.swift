//
//  Album.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public enum AlbumCategory: String, Codable {
    case PERSONAL
    case SYSTEM
}

public struct Album {
    
    public let albumId: String
    public let name: String
    public let iconUrl: String
    public let createdAt: String
    public let updatedAt: String
    public let userId: String
    public let category: String
    public let description: String
    public let banner: String?
    public var orderedAt: Int
    public var isAdded: Bool
    public var isVerified: Bool
    
}

extension Album: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case albumId = "album_id"
        case name
        case iconUrl = "icon_url"
        case createdAt = "created_at"
        case updatedAt = "update_at"
        case userId = "user_id"
        case category
        case description
        case banner
        case orderedAt = "ordered_at"
        case isAdded = "added"
        case isVerified = "is_verified"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        albumId = try container.decode(String.self, forKey: .albumId)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        iconUrl = try container.decodeIfPresent(String.self, forKey: .iconUrl) ?? ""
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        banner = try container.decodeIfPresent(String.self, forKey: .banner)
        orderedAt = try container.decodeIfPresent(Int.self, forKey: .orderedAt) ?? 0
        isAdded = try container.decodeIfPresent(Bool.self, forKey: .isAdded) ?? false
        isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified) ?? false
    }
    
}
