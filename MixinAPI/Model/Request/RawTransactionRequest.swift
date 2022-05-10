//
//  RawTransactionRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct RawTransactionRequest: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case opponentMultisig = "opponent_multisig"
        case amount
        case pin = "pin_base64"
        case traceID = "trace_id"
        case memo
    }
    
    public let assetID: String
    public let opponentMultisig: OpponentMultisig
    public let amount: String
    public var pin: String
    public let traceID: String
    public let memo: String
    
    public init(assetID: String, opponentMultisig: OpponentMultisig, amount: String, pin: String, traceID: String, memo: String) {
        self.assetID = assetID
        self.opponentMultisig = opponentMultisig
        self.amount = amount
        self.pin = pin
        self.traceID = traceID
        self.memo = memo
    }
    
}

public struct OpponentMultisig: Encodable {
    
    public let receivers: [String]
    public let threshold: Int
    
    public init(receivers: [String], threshold: Int) {
        self.receivers = receivers
        self.threshold = threshold
    }
    
}
