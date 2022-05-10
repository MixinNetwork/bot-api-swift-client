//
//  BlazeMessageData.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public class BlazeMessageData: Decodable {
    
    public let conversationID: String
    public let userID: String
    public let messageID: String
    public let category: String
    public let data: String
    public let status: String
    public let createdAt: String
    public let updatedAt: String
    public let source: String
    public let quoteMessageID: String
    public let representativeID: String
    public let sessionID: String
    
    public var silentNotification: Bool {
        isSilent ?? false
    }
    
    private let isSilent: Bool?
    
    enum CodingKeys: String, CodingKey {
        case conversationID = "conversation_id"
        case userID = "user_id"
        case messageID = "message_id"
        case category
        case data
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case source
        case quoteMessageID = "quote_message_id"
        case representativeID = "representative_id"
        case sessionID = "session_id"
        case isSilent = "silent"
    }
    
}
