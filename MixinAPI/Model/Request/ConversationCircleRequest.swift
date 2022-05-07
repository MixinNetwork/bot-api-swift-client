//
//  ConversationCircleRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct ConversationCircleRequest {
    
    public let circleId: String
    public let action: CircleConversationAction
    
    public init(circleId: String, action: CircleConversationAction) {
        self.circleId = circleId
        self.action = action
    }
    
}

extension ConversationCircleRequest: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case circleId = "circle_id"
        case action
    }
    
}
