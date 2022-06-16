//
//  SwapResponse.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/14.
//

import Foundation

struct SwapResponse<Data: Decodable>: Decodable {
    
    let code: Int
    let success: Bool
    let message: String
    let data: Data
    
}
