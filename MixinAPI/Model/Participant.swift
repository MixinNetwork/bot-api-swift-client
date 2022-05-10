//
//  Participant.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct Participant {
    
    public enum Role: String {
        case owner = "OWNER"
        case admin = "ADMIN"
    }
    
    public enum Action: String {
        case add = "ADD"
        case remove = "REMOVE"
        case join = "JOIN"
        case exit = "EXIT"
        case role = "ROLE"
    }
    
    public enum Status: Int {
        case start = 0
        case success = 1
        case error = 2
    }
    
    public let conversationID: String
    public let userID: String
    public let role: String
    public let status: Int
    public let createdAt: String
    
}

extension Participant: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case conversationID = "conversation_id"
        case userID = "user_id"
        case role
        case status
        case createdAt = "created_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conversationID = try container.decode(String.self, forKey: .conversationID)
        userID = try container.decode(String.self, forKey: .userID)
        role = try container.decodeIfPresent(String.self, forKey: .role) ?? ""
        status = try container.decodeIfPresent(Int.self, forKey: .status) ?? 0
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
    }
    
}
