//
//  CircleConversationRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct CircleConversationRequest {
    
    public let action: CircleConversationAction
    public let conversationID: String
    public let userID: String?
    
}

extension CircleConversationRequest: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case action
        case conversationID = "conversation_id"
        case userID = "user_id"
    }
    
}
