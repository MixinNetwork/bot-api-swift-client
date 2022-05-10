//
//  ConversationCircleRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct ConversationCircleRequest {
    
    public let circleID: String
    public let action: CircleConversationAction
    
    public init(circleID: String, action: CircleConversationAction) {
        self.circleID = circleID
        self.action = action
    }
    
}

extension ConversationCircleRequest: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case circleID = "circle_id"
        case action
    }
    
}
