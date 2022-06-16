//
//  PaymentAsset.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/14.
//

import Foundation

struct PaymentAsset: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case iconURL = "iconUrl"
        case assetID = "assetId"
        case network
        case chainAsset
    }
    
    let name: String
    let symbol: String
    let iconURL: URL
    let assetID: String
    let network: String
    let chainAsset: ChainAsset
    
}

extension PaymentAsset: Identifiable {
    
    var id: String {
        assetID
    }
    
}
