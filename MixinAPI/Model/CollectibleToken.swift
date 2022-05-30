//
//  CollectibleToken.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct CollectibleToken: Codable {
    
    public let id: String
    public let type: String
    public let groupKey: String
    public let tokenKey: String
    public let createdAt: String
    public let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case id = "token_id"
        case type
        case groupKey = "group"
        case tokenKey = "token"
        case createdAt = "created_at"
        case meta
    }
    
}

extension CollectibleToken {
    
    public struct Meta: Codable {
        
        public let groupName: String
        public let tokenName: String
        public let description: String
        public let iconURL: String
        public let mediaURL: String
        public let mime: String
        public let hash: String
        
        enum CodingKeys: String, CodingKey {
            case groupName = "group"
            case tokenName = "name"
            case description
            case iconURL = "icon_url"
            case mediaURL = "media_url"
            case mime
            case hash
        }
        
    }
    
}
