//
//  BlazeMessageData.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public class BlazeMessageData: Decodable {
    
    public let conversationId: String
    public let userId: String
    public let messageId: String
    public let category: String
    public let data: String
    public let status: String
    public let createdAt: String
    public let updatedAt: String
    public let source: String
    public let quoteMessageId: String
    public let representativeId: String
    public let sessionId: String
    
    public var silentNotification: Bool {
        isSilent ?? false
    }
    
    private let isSilent: Bool?
    
    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
        case userId = "user_id"
        case messageId = "message_id"
        case category
        case data
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case source
        case quoteMessageId = "quote_message_id"
        case representativeId = "representative_id"
        case sessionId = "session_id"
        case isSilent = "silent"
    }
    
}
