//
//  QRCodeResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct QRCodeResponse: Encodable {
    
    public let type: String
    public var user: User? = nil
    public var conversation: ConversationResponse? = nil
    public var authorization: AuthorizationResponse? = nil
    public var multisig: MultisigResponse? = nil
    public var collectible: CollectibleResponse? = nil
    public var payment: PaymentCodeResponse? = nil
    
}

extension QRCodeResponse: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        switch type {
        case "user":
            user = try User(from: decoder)
        case "conversation":
            conversation = try ConversationResponse(from: decoder)
        case "authorization":
            authorization = try AuthorizationResponse(from: decoder)
        case "multisig_request":
            multisig = try MultisigResponse(from: decoder)
        case "non_fungible_request":
            collectible = try CollectibleResponse(from: decoder)
        case "payment":
            payment = try PaymentCodeResponse(from: decoder)
        default:
            break
        }
    }
    
}
