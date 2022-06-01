//
//  WalletViewModel.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import Foundation
import MixinAPI

class WalletViewModel: ObservableObject {
    
    enum State {
        case waiting
        case loading
        case success
        case failure(Error)
        
        var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }
    
    enum SnapshotState {
        case waiting
        case loading
        case reachedEnd
        case failure(Error)
    }
    
    @Published private(set) var state: State = .waiting
    @Published private(set) var usdBalance: String = ""
    @Published private(set) var btcBalance: String = ""
    @Published private(set) var items: [AssetItem] = []
    
    @Published private(set) var snapshots: [String: [SnapshotItem]] = [:]
    @Published private(set) var snapshotsState: [String: SnapshotState] = [:]
    
    private let api: API
    private let snapshotLimit = 30
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
        guard !state.isLoading else {
            return
        }
        state = .loading
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
                            self.state = .failure(error)
                        }
                        return
                    }
                }
                let items: [AssetItem] = assets.map { asset in
                    let chainIconURL: URL?
                    if let chain = assets.first(where: { $0.id == asset.chainID }) {
                        chainIconURL = URL(string: chain.iconURL)
                    } else {
                        chainIconURL = nil
                    }
                    return AssetItem(asset: asset, chainIconURL: chainIconURL)
                }.sorted { one, another in
                    switch one.decimalUSDBalance.compare(to: another.decimalUSDBalance) {
                    case .orderedAscending:
                        return false
                    case .orderedSame:
                        switch one.decimalUSDPrice.compare(to: another.decimalUSDPrice) {
                        case .orderedAscending:
                            return false
                        case .orderedSame:
                            return one.decimalBalance > another.decimalBalance
                        case .orderedDescending:
                            return true
                        }
                    case .orderedDescending:
                        return true
                    }
                }
                let (totalUSDBalance, totalBTCBalance) = items.reduce((0, 0)) { partialResult, asset in
                    (partialResult.0 + asset.decimalUSDBalance, partialResult.1 + asset.decimalBTCBalance)
                }
                let localizedUSDBalance = CurrencyFormatter.localizedString(from: totalUSDBalance, format: .fiatMoney, sign: .never)
                let localizedBTCBalance = CurrencyFormatter.localizedString(from: totalBTCBalance, format: .precision, sign: .never)
                DispatchQueue.main.async {
                    self.usdBalance = localizedUSDBalance
                    self.btcBalance = localizedBTCBalance
                    self.items = items
                    self.state = .success
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .failure(error)
                }
            }
        }
    }
    
    func loadSnapshots(assetID: String) {
        switch snapshotsState[assetID] {
        case .loading, .reachedEnd:
            return
        case .waiting, .failure, .none:
            break
        }
        let assetItems = self.items
        let limit = self.snapshotLimit
        let currentSnapshots = snapshots[assetID] ?? []
        let offset = currentSnapshots.last?.snapshot.createdAt
        snapshotsState[assetID] = .loading
        api.asset.snapshots(limit: limit, offset: offset, assetID: assetID, queue: .global()) { result in
            switch result {
            case .success(let snapshots):
                let items: [SnapshotItem] = snapshots.map { snapshot in
                    let item = assetItems.first(where: { $0.asset.id == snapshot.assetID })
                    return SnapshotItem(snapshot: snapshot,
                                        assetSymbol: item?.asset.symbol ?? "",
                                        assetIcon: item?.icon ?? .none)
                }
                DispatchQueue.main.async {
                    self.snapshots[assetID] = currentSnapshots + items
                    self.snapshotsState[assetID] = snapshots.count < limit ? .reachedEnd : .waiting
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.snapshotsState[assetID] = .failure(error)
                }
            }
        }
    }
    
    func loadSnapshotsIfEmpty(assetID: String) {
        if let snapshots = snapshots[assetID], !snapshots.isEmpty {
            return
        }
        loadSnapshots(assetID: assetID)
    }
    
}
