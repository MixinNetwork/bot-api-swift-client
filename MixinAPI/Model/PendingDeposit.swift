//
//  PendingDeposit.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct PendingDeposit {
    
    public let transactionID: String
    public let transactionHash: String
    public let sender: String
    public let amount: String
    public let confirmations: Int
    public let threshold: Int
    public let createdAt: String
    
}

extension PendingDeposit: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case transactionHash = "transaction_hash"
        case sender
        case amount
        case confirmations
        case threshold
        case createdAt = "created_at"
    }
    
}
