//
//  CircleResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct CircleResponse {
    
    public let type: String
    public let circleId: String
    public let name: String
    public let createdAt: String
    
}

extension CircleResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case type
        case circleId = "circle_id"
        case name
        case createdAt = "created_at"
    }
    
}
