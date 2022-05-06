//
//  Asset.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public class Asset: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case type
        case symbol
        case name
        case iconURL = "icon_url"
        case balance
        case destination
        case tag
        case priceBTC = "price_btc"
        case priceUSD = "price_usd"
        case changeUSD = "change_usd"
        case chainID = "chain_id"
        case confirmations
        case assetKey = "asset_key"
        case reserve
    }
    
    public let assetID: String
    public let type: String
    public let symbol: String
    public let name: String
    public let iconURL: String
    public let balance: String
    public let destination: String
    public let tag: String
    public let priceBTC: String
    public let priceUSD: String
    public let changeUSD: String
    public let chainID: String
    public let confirmations: Int
    public let assetKey: String
    public let reserve: String
    
    public init(assetID: String, type: String, symbol: String, name: String, iconURL: String, balance: String, destination: String, tag: String, priceBTC: String, priceUSD: String, changeUSD: String, chainID: String, confirmations: Int, assetKey: String, reserve: String) {
        self.assetID = assetID
        self.type = type
        self.symbol = symbol
        self.name = name
        self.iconURL = iconURL
        self.balance = balance
        self.destination = destination
        self.tag = tag
        self.priceBTC = priceBTC
        self.priceUSD = priceUSD
        self.changeUSD = changeUSD
        self.chainID = chainID
        self.confirmations = confirmations
        self.assetKey = assetKey
        self.reserve = reserve
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        assetID = try container.decode(String.self, forKey: .assetID)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        iconURL = try container.decodeIfPresent(String.self, forKey: .iconURL) ?? ""
        balance = try container.decodeIfPresent(String.self, forKey: .balance) ?? ""
        destination = try container.decodeIfPresent(String.self, forKey: .destination) ?? ""
        tag = try container.decodeIfPresent(String.self, forKey: .tag) ?? ""
        priceBTC = try container.decodeIfPresent(String.self, forKey: .priceBTC) ?? ""
        priceUSD = try container.decodeIfPresent(String.self, forKey: .priceUSD) ?? ""
        changeUSD = try container.decodeIfPresent(String.self, forKey: .changeUSD) ?? ""
        chainID = try container.decodeIfPresent(String.self, forKey: .chainID) ?? ""
        confirmations = try container.decodeIfPresent(Int.self, forKey: .confirmations) ?? 0
        assetKey = try container.decodeIfPresent(String.self, forKey: .assetKey) ?? ""
        reserve = try container.decodeIfPresent(String.self, forKey: .reserve) ?? ""
    }
    
}
