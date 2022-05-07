//
//  PaymentResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct PaymentResponse: Decodable {
    
    public enum Status: String, Decodable {
        case pending
        case paid
    }
    
    public let status: String
    
}
