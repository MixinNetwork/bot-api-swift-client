//
//  SnapshotItem.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import Foundation
import MixinAPI

struct SnapshotItem {
    
    let snapshot: Snapshot
    let type: String
    let amount: String
    let isAmountPositive: Bool
    let assetSymbol: String
    let assetIcon: AssetIcon
    let date: String
    
    init(snapshot: Snapshot, assetSymbol: String, assetIcon: AssetIcon) {
        self.snapshot = snapshot
        self.type = (snapshot.type.first?.uppercased() ?? "") + snapshot.type.dropFirst()
        if snapshot.amount.hasPrefix("-") {
            self.amount = snapshot.amount
            self.isAmountPositive = false
        } else {
            self.amount = "+" + snapshot.amount
            self.isAmountPositive = true
        }
        self.assetSymbol = assetSymbol
        self.assetIcon = assetIcon
        if let date = DateFormatter.iso8601.date(from: snapshot.createdAt) {
            self.date = DateFormatter.general.string(from: date)
        } else {
            self.date = snapshot.createdAt
        }
    }
    
}

extension SnapshotItem: Identifiable {
    
    var id: String {
        snapshot.id
    }
    
}
