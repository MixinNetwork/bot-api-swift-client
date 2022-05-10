//
//  ConversationResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct ConversationResponse: Codable {
    
    public let conversationID: String
    public let name: String
    public let category: String
    public let iconURL: String
    public let announcement: String
    public let createdAt: String
    public let participants: [ConversationResponse.Participant]
    public let participantSessions: [UserSession]?
    public let codeURL: String
    public let creatorID: String
    public let muteUntil: String
    public let circles: [ConversationResponse.Circle]
    
    enum CodingKeys: String, CodingKey {
        case conversationID = "conversation_id"
        case name
        case category
        case iconURL = "icon_url"
        case announcement
        case createdAt = "created_at"
        case participants
        case codeURL = "code_url"
        case creatorID = "creator_id"
        case muteUntil = "mute_until"
        case participantSessions = "participant_sessions"
        case circles = "circles"
    }
    
    public init(conversationID: String, name: String, category: String, iconURL: String, announcement: String, createdAt: String, participants: [ConversationResponse.Participant], participantSessions: [UserSession]?, codeURL: String, creatorID: String, muteUntil: String, circles: [ConversationResponse.Circle]) {
        self.conversationID = conversationID
        self.name = name
        self.category = category
        self.iconURL = iconURL
        self.announcement = announcement
        self.createdAt = createdAt
        self.participants = participants
        self.participantSessions = participantSessions
        self.codeURL = codeURL
        self.creatorID = creatorID
        self.muteUntil = muteUntil
        self.circles = circles
    }
    
}

// MARK: - Embedded structs
extension ConversationResponse {
    
    public struct Circle: Codable {
        
        public let type: String
        public let circleID: String
        public let createdAt: String
        
        public enum CodingKeys: String, CodingKey {
            case type
            case circleID = "circle_id"
            case createdAt = "created_at"
        }
        
    }
    
    public struct Participant: Codable {
        
        public let userID: String
        public let role: String
        public let createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case role
            case createdAt = "created_at"
        }
        
        public init(userID: String, role: String, createdAt: String) {
            self.userID = userID
            self.role = role
            self.createdAt = createdAt
        }
        
    }
    
}
