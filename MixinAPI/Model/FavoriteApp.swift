//
//  FavoriteApp.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct FavoriteApp {
    
    public let userId: String
    public let appId: String
    public let createdAt: String
    
}

extension FavoriteApp: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case appId = "app_id"
        case createdAt = "created_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        appId = try container.decode(String.self, forKey: .appId)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
    }
    
}
