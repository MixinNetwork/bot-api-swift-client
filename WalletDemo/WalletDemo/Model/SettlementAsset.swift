//
//  SettlementAsset.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/15.
//

import Foundation

struct SettlementAsset: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case iconURL = "iconUrl"
        case assetID = "assetId"
        case network
        case isAsset
        case chainAsset
    }
    
    let name: String
    let symbol: String
    let iconURL: URL
    let assetID: String
    let network: String
    let isAsset: Bool
    let chainAsset: ChainAsset
    
}

extension SettlementAsset: Identifiable {
    
    var id: String {
        assetID
    }
    
}
