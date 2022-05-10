//
//  Address.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct Address {
    
    public let type: String
    public let addressID: String
    public let assetID: String
    public let destination: String
    public let label: String
    public let tag: String
    public let fee: String
    public let reserve: String
    public let dust: String
    public let updatedAt: String
    
}

extension Address: Codable {
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case type
        case addressID = "address_id"
        case assetID = "asset_id"
        case destination
        case label
        case tag
        case fee
        case reserve
        case dust
        case updatedAt = "updated_at"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        addressID = try container.decode(String.self, forKey: .addressID)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        assetID = try container.decodeIfPresent(String.self, forKey: .assetID) ?? ""
        destination = try container.decodeIfPresent(String.self, forKey: .destination) ?? ""
        label = try container.decodeIfPresent(String.self, forKey: .label) ?? ""
        tag = try container.decodeIfPresent(String.self, forKey: .tag) ?? ""
        fee = try container.decodeIfPresent(String.self, forKey: .fee) ?? ""
        reserve = try container.decodeIfPresent(String.self, forKey: .reserve) ?? ""
        dust = try container.decodeIfPresent(String.self, forKey: .dust) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
    
}
