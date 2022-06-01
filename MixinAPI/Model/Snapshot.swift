//
//  Snapshot.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct Snapshot {
    
    public let id: String
    public let type: String
    public let assetID: String
    public let amount: String
    public let opponentID: String?
    public let transactionHash: String?
    public let sender: String?
    public let receiver: String?
    public let memo: String?
    public let confirmations: Int?
    public let traceID: String?
    public let createdAt: String
    
    public init(id: String, type: String, assetID: String, amount: String, transactionHash: String?, sender: String?, opponentID: String?, memo: String?, receiver: String?, confirmations: Int?, traceID: String?, createdAt: String) {
        self.id = id
        self.type = type
        self.assetID = assetID
        self.amount = amount
        self.transactionHash = transactionHash
        self.sender = sender
        self.opponentID = opponentID
        self.memo = memo
        self.receiver = receiver
        self.confirmations = confirmations
        self.traceID = traceID
        self.createdAt = createdAt
    }
    
}

extension Snapshot: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case id = "snapshot_id"
        case type
        case assetID = "asset_id"
        case amount
        case opponentID = "opponent_id"
        case transactionHash = "transaction_hash"
        case sender
        case receiver
        case memo
        case confirmations
        case traceID = "trace_id"
        case createdAt = "created_at"
    }
    
}
