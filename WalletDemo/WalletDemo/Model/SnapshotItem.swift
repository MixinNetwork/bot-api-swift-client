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
    let usdAmount: String
    let assetSymbol: String
    let assetName: String?
    let assetIcon: AssetIcon
    let date: String
    
    init(snapshot: Snapshot, assetItem: AssetItem?) {
        let decimalAmount = Decimal(string: snapshot.amount) ?? 0
        let decimalUSDAmount = decimalAmount * (assetItem?.decimalUSDPrice ?? 0)
        let localizedUSDAmount = CurrencyFormatter.localizedString(from: decimalUSDAmount, format: .fiatMoney, sign: .never, symbol: .usd)
        
        self.snapshot = snapshot
        self.type = (snapshot.type.first?.uppercased() ?? "") + snapshot.type.dropFirst()
        if snapshot.amount.hasPrefix("-") {
            self.amount = snapshot.amount
            self.isAmountPositive = false
        } else {
            self.amount = "+" + snapshot.amount
            self.isAmountPositive = true
        }
        self.usdAmount = localizedUSDAmount
        self.assetSymbol = assetItem?.asset.symbol ?? ""
        self.assetName = assetItem?.asset.name
        self.assetIcon = assetItem?.icon ?? .none
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
