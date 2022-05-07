//
//  ParticipantRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct ParticipantRequest: Codable {
    
    public let userId: String
    public let role: String
    
    public enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case role
    }
    
    public init(userId: String, role: String) {
        self.userId = userId
        self.role = role
    }
    
}
