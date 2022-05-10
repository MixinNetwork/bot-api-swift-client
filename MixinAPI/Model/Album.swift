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
    
    public let albumID: String
    public let name: String
    public let iconURL: String
    public let createdAt: String
    public let updatedAt: String
    public let userID: String
    public let category: String
    public let description: String
    public let banner: String?
    public var orderedAt: Int
    public var isAdded: Bool
    public var isVerified: Bool
    
}

extension Album: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case name
        case iconURL = "icon_url"
        case createdAt = "created_at"
        case updatedAt = "update_at"
        case userID = "user_id"
        case category
        case description
        case banner
        case orderedAt = "ordered_at"
        case isAdded = "added"
        case isVerified = "is_verified"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        albumID = try container.decode(String.self, forKey: .albumID)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        iconURL = try container.decodeIfPresent(String.self, forKey: .iconURL) ?? ""
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        userID = try container.decodeIfPresent(String.self, forKey: .userID) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        banner = try container.decodeIfPresent(String.self, forKey: .banner)
        orderedAt = try container.decodeIfPresent(Int.self, forKey: .orderedAt) ?? 0
        isAdded = try container.decodeIfPresent(Bool.self, forKey: .isAdded) ?? false
        isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified) ?? false
    }
    
}
