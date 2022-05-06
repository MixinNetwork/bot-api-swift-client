//
//  VerificationResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/5.
//

import Foundation

public struct VerificationResponse: Decodable {
    
    public let type: String
    public let id: String
    public let hasEmergencyContact: Bool
    public let deactivatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case hasEmergencyContact = "has_emergency_contact"
        case deactivatedAt = "deactivated_at"
    }
    
}
