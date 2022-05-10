//
//  FavoriteApp.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct FavoriteApp {
    
    public let userID: String
    public let appID: String
    public let createdAt: String
    
}

extension FavoriteApp: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case appID = "app_id"
        case createdAt = "created_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(String.self, forKey: .userID)
        appID = try container.decode(String.self, forKey: .appID)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
    }
    
}
