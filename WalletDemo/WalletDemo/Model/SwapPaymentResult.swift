//
//  SwapPaymentResult.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/20.
//

import Foundation

struct SwapPaymentResult: Decodable {
    
    enum Status: String, Decodable {
        case unpaid
        case pending
        case success
        case failed
    }
    
    let status: Status
    
}
