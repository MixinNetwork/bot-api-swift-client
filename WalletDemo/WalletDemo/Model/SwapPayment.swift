//
//  SwapPayment.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/17.
//

import Foundation

struct SwapPayment: Decodable {
    
    let isChain: Bool
    let expire: Date
    let seconds: Int
    
    let payeeID: String
    let traceID: String
    let clientID: String
    
    let paymentAssetID: String
    let paymentAmount: String
    let paymentAssetSymbol: String
    
    let quoteAssetID: String
    let quoteAmount: String
    let quoteAssetSymbol: String
    
    let settlementAssetID: String
    let estimatedSettlementAmount: String
    let settlementAssetSymbol: String
    
    let memo: String
    let recipient: String
    let destination: String
    let tag: String
    
    enum CodingKeys: String, CodingKey {
        case isChain = "isChain"
        case expire = "expire"
        case seconds = "seconds"
        
        case payeeID = "payeeId"
        case traceID = "traceId"
        case clientID = "clientId"
        
        case paymentAssetID = "paymentAssetId"
        case paymentAmount = "paymentAmount"
        case paymentAssetSymbol = "paymentAssetSymbol"
        
        case quoteAssetID = "quoteAssetId"
        case quoteAmount = "quoteAmount"
        case quoteAssetSymbol = "quoteAssetSymbol"
        
        case settlementAssetID = "settlementAssetId"
        case estimatedSettlementAmount = "estimatedSettlementAmount"
        case settlementAssetSymbol = "settlementAssetSymbol"
        
        case memo = "memo"
        case recipient = "recipient"
        case destination = "destination"
        case tag = "tag"
    }
    
}
