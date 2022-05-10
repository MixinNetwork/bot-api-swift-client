//
//  CircleConversationAction.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public enum CircleConversationAction: String {
    case add
    case remove
}

extension CircleConversationAction: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case add = "ADD"
        case remove = "REMOVE"
    }
    
}
