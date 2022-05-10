//
//  CircleConversation.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class CircleConversation: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case circleID = "circle_id"
        case conversationID = "conversation_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case pinTime = "pin_time"
        
    }
    
    public let circleID: String
    public let conversationID: String
    public let userID: String?
    public let createdAt: String
    public let pinTime: String?
    
    public init(circleID: String, conversationID: String, userID: String?, createdAt: String, pinTime: String?) {
        self.circleID = circleID
        self.conversationID = conversationID
        self.userID = userID
        self.createdAt = createdAt
        self.pinTime = pinTime
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        circleID = try container.decode(String.self, forKey: .circleID)
        conversationID = try container.decode(String.self, forKey: .conversationID)
        userID = try container.decodeIfPresent(String.self, forKey: .userID)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        pinTime = try container.decodeIfPresent(String.self, forKey: .pinTime)
    }
    
}
