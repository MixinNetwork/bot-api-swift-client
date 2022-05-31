//
//  AssetViewModel.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import Foundation
import MixinAPI

final class AssetViewModel {
    
    let assetID: String
    let assetIconURL: URL?
    let chainIconURL: URL?
    let symbol: String
    let balance: String
    let change: String
    let isChangePositive: Bool
    let usdPrice: String
    let usdBalance: String
    let decimalBalance: Decimal
    let decimalUSDPrice: Decimal
    let decimalUSDBalance: Decimal
    let decimalBTCBalance: Decimal

    init(assetID: String, assetIconURL: URL?, chainIconURL: URL?, symbol: String, balance: String, change: String, isChangePositive: Bool, usdPrice: String, usdBalance: String, decimalBalance: Decimal, decimalUSDPrice: Decimal, decimalUSDBalance: Decimal, decimalBTCBalance: Decimal) {
        self.assetID = assetID
        self.assetIconURL = assetIconURL
        self.chainIconURL = chainIconURL
        self.symbol = symbol
        self.balance = balance
        self.change = change
        self.isChangePositive = isChangePositive
        self.usdPrice = usdPrice
        self.usdBalance = usdBalance
        self.decimalBalance = decimalBalance
        self.decimalUSDPrice = decimalUSDPrice
        self.decimalUSDBalance = decimalUSDBalance
        self.decimalBTCBalance = decimalBTCBalance
    }
    
    convenience init(asset: Asset, chainIconURL: URL?) {
        let balance = Decimal(string: asset.balance) ?? 0
        let usdPrice = Decimal(string: asset.usdPrice) ?? 0
        let btcPrice = Decimal(string: asset.btcPrice) ?? 0
        let change = Decimal(string: asset.usdChange) ?? 0
        self.init(assetID: asset.id,
                  assetIconURL: URL(string: asset.iconURL),
                  chainIconURL: chainIconURL,
                  symbol: asset.symbol,
                  balance: CurrencyFormatter.localizedString(from: balance, format: .pretty, sign: .never),
                  change: CurrencyFormatter.localizedString(from: change * 100, format: .fiatMoney, sign: .whenNegative, symbol: .percentage),
                  isChangePositive: !asset.usdChange.hasPrefix("-"),
                  usdPrice: CurrencyFormatter.localizedString(from: usdPrice, format: .fiatMoneyPrice, sign: .never, symbol: .usd),
                  usdBalance: CurrencyFormatter.localizedString(from: balance * usdPrice, format: .fiatMoney, sign: .never, symbol: .usd),
                  decimalBalance: balance,
                  decimalUSDPrice: usdPrice,
                  decimalUSDBalance: balance * usdPrice,
                  decimalBTCBalance: balance * btcPrice)
    }
    
}

extension AssetViewModel: Identifiable {
    
    public var id: String {
        assetID
    }
    
}
