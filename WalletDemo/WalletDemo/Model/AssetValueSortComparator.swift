//
//  AssetValueSortComparator.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import Foundation

infix operator ~>: NilCoalescingPrecedence

fileprivate extension ComparisonResult {
    
    static func ~>(_ lhs: ComparisonResult, _ rhs: ComparisonResult) -> ComparisonResult {
        switch lhs {
        case .orderedAscending, .orderedDescending:
            return lhs
        case .orderedSame:
            return rhs
        }
    }
    
}

final class AssetValueSortComparator: NSObject, SortComparator {
    
    var order: SortOrder = .forward
    
    func compare(_ lhs: AssetItem, _ rhs: AssetItem) -> ComparisonResult {
        let result = lhs.decimalUSDBalance.compare(to: rhs.decimalUSDBalance)
            ~> lhs.decimalUSDPrice.compare(to: rhs.decimalUSDPrice)
            ~> lhs.decimalBalance.compare(to: rhs.decimalBalance)
        let isOrderForward = order == .forward
        switch result {
        case .orderedAscending:
            return isOrderForward ? .orderedDescending : .orderedAscending
        case .orderedSame:
            return .orderedSame
        case .orderedDescending:
            return isOrderForward ? .orderedAscending : .orderedDescending
        }
    }
    
}
