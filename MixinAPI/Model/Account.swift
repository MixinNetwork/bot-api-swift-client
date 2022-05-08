//
//  Account.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/5.
//

import Foundation

public struct Account {
    
    public enum ReceiveMessageSource: String {
        case everybody = "EVERYBODY"
        case contacts = "CONTACTS"
    }
    
    public enum AcceptConversationSource: String {
        case everybody = "EVERYBODY"
        case contacts = "CONTACTS"
    }
    
    public enum AcceptSearchSource: String {
        case everybody = "EVERYBODY"
        case contacts = "CONTACTS"
        case nobody = "NOBODY"
    }
    
    public let userId: String
    public let sessionId: String
    public let type: String
    public let identityNumber: String
    public let fullName: String
    public let biography: String
    public let avatarUrl: String
    public let phone: String
    public let authenticationToken: String
    public let codeId: String
    public let codeUrl: String
    public let reputation: Int
    public let createdAt: String
    public let receiveMessageSource: String
    public let acceptConversationSource: String
    public let acceptSearchSource: String
    public let hasPIN: Bool
    public let hasEmergencyContact: Bool
    public let pinToken: String
    public let fiatCurrency: String
    public let transferNotificationThreshold: Double
    public let transferConfirmationThreshold: Double
    
}

extension Account: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case sessionId = "session_id"
        case type
        case identityNumber = "identity_number"
        case fullName = "full_name"
        case biography
        case avatarUrl = "avatar_url"
        case phone
        case authenticationToken = "authentication_token"
        case codeId = "code_id"
        case codeUrl = "code_url"
        case reputation
        case createdAt = "created_at"
        case receiveMessageSource = "receive_message_source"
        case acceptConversationSource = "accept_conversation_source"
        case acceptSearchSource = "accept_search_source"
        case hasPIN = "has_pin"
        case hasEmergencyContact = "has_emergency_contact"
        case pinToken = "pin_token"
        case fiatCurrency = "fiat_currency"
        case transferNotificationThreshold = "transfer_notification_threshold"
        case transferConfirmationThreshold = "transfer_confirmation_threshold"
    }
    
}
