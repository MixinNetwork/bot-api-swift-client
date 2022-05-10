//
//  WithdrawalRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct WithdrawalRequest: Codable {
    
    public let addressID: String
    public let amount: String
    public let traceID: String
    public var pin: String
    public let memo: String
    
    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case amount
        case traceID = "trace_id"
        case memo
        case pin = "pin_base64"
    }
    
    public init(addressID: String, amount: String, traceID: String, pin: String, memo: String) {
        self.addressID = addressID
        self.amount = amount
        self.traceID = traceID
        self.pin = pin
        self.memo = memo
    }
    
}
