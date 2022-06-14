//
//  AssetItem.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import Foundation
import MixinAPI

struct AssetItem {
    
    let asset: Asset
    let icon: AssetIcon
    let balance: String
    let change: String
    let isChangePositive: Bool
    let usdPrice: String
    let usdBalance: String
    let decimalBalance: Decimal
    let decimalUSDPrice: Decimal
    let decimalUSDBalance: Decimal
    let decimalBTCBalance: Decimal
    
    init(asset: Asset, chainIconURL: URL?) {
        let balance = Decimal(string: asset.balance) ?? 0
        let usdPrice = Decimal(string: asset.usdPrice) ?? 0
        let btcPrice = Decimal(string: asset.btcPrice) ?? 0
        let change = Decimal(string: asset.usdChange) ?? 0
        
        self.asset = asset
        self.icon = AssetIcon(asset: URL(string: asset.iconURL), chain: chainIconURL)
        self.balance = CurrencyFormatter.localizedString(from: balance, format: .pretty, sign: .never)
        self.change = CurrencyFormatter.localizedString(from: change * 100, format: .fiatMoney, sign: .whenNegative, symbol: .percentage)
        self.isChangePositive = !asset.usdChange.hasPrefix("-")
        self.usdPrice = CurrencyFormatter.localizedString(from: usdPrice, format: .fiatMoneyPrice, sign: .never, symbol: .usd)
        self.usdBalance = CurrencyFormatter.localizedString(from: balance * usdPrice, format: .fiatMoney, sign: .never, symbol: .usd)
        
        self.decimalBalance = balance
        self.decimalUSDPrice = usdPrice
        self.decimalUSDBalance = balance * usdPrice
        self.decimalBTCBalance = balance * btcPrice
    }
    
}

extension AssetItem: Identifiable {
    
    public var id: String {
        asset.id
    }
    
}
