//
//  CircleConversationRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct CircleConversationRequest {
    
    public let action: CircleConversationAction
    public let conversationId: String
    public let userId: String?
    
}

extension CircleConversationRequest: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case action
        case conversationId = "conversation_id"
        case userId = "user_id"
    }
    
}
