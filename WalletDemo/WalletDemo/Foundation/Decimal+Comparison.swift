//
//  Decimal+Comparison.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/31.
//

import Foundation

extension Decimal {
    
    func compare(to number: Decimal) -> ComparisonResult {
        withUnsafePointer(to: self) { this in
            withUnsafePointer(to: number) { that in
                NSDecimalCompare(this, that)
            }
        }
    }
    
}
