//
//  SwappableAsset.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import Foundation

struct SwappableAsset: Identifiable {
    
    let id: String
    let symbol: String
    let icon: AssetIcon
    let minQuoteAmount: Decimal
    let maxQuoteAmount: Decimal
    let decimalDigit: UInt
    
}
