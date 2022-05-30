//
//  AssetViewModel.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import Foundation
import MixinAPI

class AssetViewModel {
    
    let assetID: String
    let assetIconURL: URL?
    let chainIconURL: URL?
    let symbol: String
    let balance: String
    let change: String
    let isChangePositive: Bool
    let fiatMoneyPrice: String
    let fiatMoneyBalance: String
    
    init(assetID: String, assetIconURL: URL?, chainIconURL: URL?, symbol: String, balance: String, change: String, isChangePositive: Bool, fiatMoneyPrice: String, fiatMoneyBalance: String) {
        self.assetID = assetID
        self.assetIconURL = assetIconURL
        self.chainIconURL = chainIconURL
        self.symbol = symbol
        self.balance = balance
        self.change = change
        self.isChangePositive = isChangePositive
        self.fiatMoneyPrice = fiatMoneyPrice
        self.fiatMoneyBalance = fiatMoneyBalance
    }
    
    convenience init(asset: Asset, chainIconURL: URL?) {
        let localizedChange = (CurrencyFormatter.localizedString(from: asset.usdChange.doubleValue * 100, format: .fiatMoney, sign: .whenNegative) ?? "0.00") + "%"
        
        let fiatMoneyBalance = asset.balance.doubleValue * asset.usdPrice.doubleValue
        let localizedFiatMoneyBalance: String
        if let value = CurrencyFormatter.localizedString(from: fiatMoneyBalance, format: .fiatMoney, sign: .never) {
            localizedFiatMoneyBalance = "≈ $" + value
        } else {
            localizedFiatMoneyBalance = ""
        }
        
        let localizedFiatMoneyPrice = "$" + (CurrencyFormatter.localizedString(from: asset.usdPrice, format: .fiatMoneyPrice, sign: .never) ?? "")
        
        self.init(assetID: asset.id,
                  assetIconURL: URL(string: asset.iconURL),
                  chainIconURL: chainIconURL,
                  symbol: asset.symbol,
                  balance: CurrencyFormatter.localizedString(from: asset.balance, format: .pretty, sign: .never) ?? "",
                  change: localizedChange,
                  isChangePositive: !asset.usdChange.hasPrefix("-"),
                  fiatMoneyPrice: localizedFiatMoneyPrice,
                  fiatMoneyBalance: localizedFiatMoneyBalance)
    }
    
}

extension AssetViewModel: Identifiable {
    
    public var id: String {
        assetID
    }
    
}
