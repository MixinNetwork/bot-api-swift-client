//
//  WalletViewModel.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import Foundation
import MixinAPI

class WalletViewModel: ObservableObject {
    
    struct Representation {
        let fiatMoneyBalance: String
        let btcBalance: String
        let assets: [AssetViewModel]
    }
    
    @Published var result: Result<Representation, Error>?
    
    private let api: API
    private let fixedAssetIDs = [
        "c6d0c728-2624-429b-8e0d-d9d19b6592fa", // BTC
        "43d61dcd-e413-450d-80b8-101d5e903357", // ETH
        "4d8c508b-91c5-375b-92b0-ee702ed2dac5", // USDT(Ethereum)
        "6770a1e5-6086-44d5-b60f-545f9d9e8ffd", // DOGE
    ]
    
    init(api: API) {
        self.api = api
    }
    
    func reloadAssets() {
        let api = self.api
        api.asset.assets(queue: .global()) { result in
            switch result {
            case .success(var assets):
                var missingAssetIDs = Set(self.fixedAssetIDs)
                missingAssetIDs.formUnion(assets.map(\.chainID))
                missingAssetIDs.subtract(assets.map(\.id))
                for id in missingAssetIDs {
                    let result = api.asset.asset(assetID: id)
                    switch result {
                    case let .success(asset):
                        assets.append(asset)
                    case let .failure(error):
                        DispatchQueue.main.async {
                            self.result = .failure(error)
                        }
                        return
                    }
                }
                assets.sort { one, another in
                    let oneUSDBalance = one.balance.doubleValue * one.usdPrice.doubleValue
                    let anotherUSDBalance = another.balance.doubleValue * another.usdPrice.doubleValue
                    if oneUSDBalance > anotherUSDBalance {
                        return true
                    } else if oneUSDBalance < anotherUSDBalance {
                        return false
                    } else {
                        return one.usdPrice.doubleValue > another.usdPrice.doubleValue
                    }
                }
                let viewModels: [AssetViewModel] = assets.map { asset in
                    let chainIconURL: URL?
                    if let chain = assets.first(where: { $0.id == asset.chainID }) {
                        chainIconURL = URL(string: chain.iconURL)
                    } else {
                        chainIconURL = nil
                    }
                    return AssetViewModel(asset: asset, chainIconURL: chainIconURL)
                }
                
                var fiatMoneyBalance: Double = 0
                var btcBalance: Double = 0
                for asset in assets {
                    let balance = asset.balance.doubleValue
                    fiatMoneyBalance += balance * asset.usdPrice.doubleValue
                    btcBalance += balance * asset.btcPrice.doubleValue
                }
                let representation = Representation(fiatMoneyBalance: CurrencyFormatter.localizedString(from: fiatMoneyBalance, format: .fiatMoney, sign: .never) ?? "0.00",
                                                    btcBalance: CurrencyFormatter.localizedString(from: btcBalance, format: .precision, sign: .never) ?? "0.00",
                                                    assets: viewModels)
                
                DispatchQueue.main.async {
                    self.result = .success(representation)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.result = .failure(error)
                }
            }
        }
    }
    
}
