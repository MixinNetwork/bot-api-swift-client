//
//  UserPreferenceRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/6.
//

import Foundation

public struct UserPreferenceRequest {
    
    public let fullName: String?
    public let avatarBase64: String?
    public let notificationToken: String?
    public let receiveMessageSource: String?
    public let acceptConversationSource: String?
    public let acceptSearchSource: String?
    public let fiatCurrency: String?
    public let transferNotificationThreshold: Double?
    public let transferConfirmationThreshold: Double?
    
}

extension UserPreferenceRequest: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case avatarBase64 = "avatar_base64"
        case notificationToken = "notification_token"
        case receiveMessageSource = "receive_message_source"
        case acceptConversationSource = "accept_conversation_source"
        case acceptSearchSource = "accept_search_source"
        case fiatCurrency = "fiat_currency"
        case transferNotificationThreshold = "transfer_notification_threshold"
        case transferConfirmationThreshold = "transfer_confirmation_threshold"
    }
    
}
