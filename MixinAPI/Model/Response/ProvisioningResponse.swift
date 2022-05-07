//
//  ProvisioningResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct ProvisioningResponse {
    
    public let type: String
    public let deviceId: String
    public let description: String
    public let secret: String
    public let createdAt: String
    
}

extension ProvisioningResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case deviceId = "device_id"
        case description
        case secret
        case createdAt = "created_at"
    }
    
}
