//
//  RelationshipRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct RelationshipRequest {
    
    public enum Action: String, Encodable {
        case add = "ADD"
        case remove = "REMOVE"
        case update = "UPDATE"
        case block = "BLOCK"
        case unblock = "UNBLOCK"
    }
    
    let userID: String
    let fullName: String?
    let action: Action
    
}

extension RelationshipRequest: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case fullName = "full_name"
        case action
    }
    
}
