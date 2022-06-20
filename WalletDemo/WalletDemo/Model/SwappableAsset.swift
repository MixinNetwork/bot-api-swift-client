//
//  SwappableAsset.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import Foundation

struct SwappableAsset: Identifiable {
    
    let id: String
    let minQuoteAmount: Decimal
    let minQuoteAmountString: String
    let maxQuoteAmount: Decimal
    let maxQuoteAmountString: String
    let decimalDigit: UInt
    
}
