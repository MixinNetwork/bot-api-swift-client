//
//  SwapPaymentResult.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/20.
//

import Foundation

struct SwapPaymentResult: Decodable {
    
    enum Status: String, Decodable {
        case unpaid, success, failed
    }
    
    let status: Status
    
}
