//
//  QuoteAsset.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import Foundation

struct QuoteAsset: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case iconURL = "iconUrl"
        case minQuoteAmount
        case maxQuoteAmount
        case decimalDigit
        case isAsset
        case assetID = "assetId"
    }
    
    let symbol: String
    let iconURL: URL
    let minQuoteAmount: String
    let maxQuoteAmount: String
    let decimalDigit: UInt
    let isAsset: Int
    let assetID: String
    
}

extension QuoteAsset: Identifiable {
    
    var id: String {
        assetID
    }
    
}
