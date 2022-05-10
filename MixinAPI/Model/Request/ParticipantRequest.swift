//
//  ParticipantRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct ParticipantRequest: Codable {
    
    public let userID: String
    public let role: String
    
    public enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case role
    }
    
    public init(userID: String, role: String) {
        self.userID = userID
        self.role = role
    }
    
}
