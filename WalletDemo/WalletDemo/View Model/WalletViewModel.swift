//
//  WalletViewModel.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import Foundation
import MixinAPI
import SwiftUI

class WalletViewModel: ObservableObject {
    
    enum State {
        case waiting
        case loading
        case success
        case failure(Error)
    }
    
    enum SnapshotState {
        case waiting
        case loading
        case reachedEnd
        case failure(Error)
    }
    
    @Published private(set) var assetsState: State = .waiting
    @Published private(set) var assetItems: [AssetItem] = []
    @Published private(set) var usdBalance: String = ""
    @Published private(set) var btcBalance: String = ""
    
    @Published private(set) var snapshots: [String: [SnapshotItem]] = [:]
    @Published private(set) var snapshotsState: [String: SnapshotState] = [:]
    
    @Published private(set) var addresses: [String: [AddressItem]] = [:]
    @Published private(set) var addressesState: [String: State] = [:]
    
    private(set) var onPINInput: ((String) -> Void)?
    @Published private(set) var pinVerificationState: State = .waiting
    @Published private(set) var pinVerificationCaption = "Transfer"
    @Published private(set) var isPINVerificationPresented = false
    
    private let api: API
    private let snapshotLimit = 30
    private let fixedAssetIDs = [
        AssetID.bitcoin,
        AssetID.ethereum,
        AssetID.usdtEthereum,
        AssetID.doge,
    ]
    
    init(api: API) {
        self.api = api
    }
    
    func dismissPINVerification() {
        isPINVerificationPresented = false
    }
    
}

// MARK: - Asset
extension WalletViewModel {
    
    func reloadAssets() {
        if case .loading = assetsState {
            return
        }
        assetsState = .loading
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
                            self.assetsState = .failure(error)
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
                    self.assetItems = items
                    self.assetsState = .success
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.assetsState = .failure(error)
                }
            }
        }
    }
    
}

// MARK: - Snapshot
extension WalletViewModel {
    
    func loadSnapshotsIfEmpty(assetID: String) {
        if let snapshots = snapshots[assetID], !snapshots.isEmpty {
            return
        }
        loadSnapshots(assetID: assetID)
    }
    
    func loadSnapshots(assetID: String) {
        switch snapshotsState[assetID] {
        case .loading, .reachedEnd:
            return
        case .waiting, .failure, .none:
            break
        }
        snapshotsState[assetID] = .loading
        let assetItems = self.assetItems
        let limit = self.snapshotLimit
        let currentSnapshots = snapshots[assetID] ?? []
        let offset = currentSnapshots.last?.snapshot.createdAt
        api.asset.snapshots(limit: limit, offset: offset, assetID: assetID, queue: .global()) { result in
            switch result {
            case .success(let snapshots):
                let items: [SnapshotItem] = snapshots.map { snapshot in
                    let item = assetItems.first(where: { $0.asset.id == snapshot.assetID })
                    return SnapshotItem(snapshot: snapshot, assetItem: item)
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
    
}

// MARK: - Address
extension WalletViewModel {

    func loadAddress(assetID: String) {
        switch addressesState[assetID] {
        case .loading, .success:
            return
        case .waiting, .failure, .none:
            break
        }
        addressesState[assetID] = .loading
        api.withdrawal.addresses(assetID: assetID) { result in
            switch result {
            case let .success(addresses):
                self.addresses[assetID] = addresses.map(AddressItem.init(address:))
                self.addressesState[assetID] = .success
            case let .failure(error):
                self.addressesState[assetID] = .failure(error)
            }
        }
    }
    
    func saveAddress(assetID: String, label: String, address: String, memo: String, onSuccess: @escaping () -> Void) {
        onPINInput = { (pin) in
            self.pinVerificationState = .loading
            let request = AddressRequest(assetID: assetID, destination: address, tag: memo, label: label, pin: pin)
            self.api.withdrawal.save(address: request) { result in
                switch result {
                case let .success(address):
                    let item = AddressItem(address: address)
                    var addresses = self.addresses[assetID] ?? []
                    addresses.append(item)
                    self.addresses[assetID] = addresses
                    self.pinVerificationState = .success
                    onSuccess()
                case let .failure(error):
                    self.pinVerificationState = .failure(error)
                }
            }
        }
        pinVerificationState = .waiting
        pinVerificationCaption = "Add Address"
        isPINVerificationPresented = true
    }
    
    func deleteAddress(id: String, assetID: String) {
        onPINInput = { (pin) in
            self.pinVerificationState = .loading
            self.api.withdrawal.delete(addressID: id, pin: pin) { result in
                switch result {
                case .success:
                    self.addresses[assetID]?.removeAll(where: { item in
                        item.address.id == id
                    })
                    self.pinVerificationState = .success
                case let .failure(error):
                    self.pinVerificationState = .failure(error)
                }
            }
        }
        pinVerificationState = .waiting
        pinVerificationCaption = "Delete Address"
        isPINVerificationPresented = true
    }
    
}

// MARK: - Withdraw
extension WalletViewModel {
    
    func withdraw(amount: String, toAddressWith addressID: String, onSuccess: @escaping () -> Void) {
        onPINInput = { (pin) in
            self.pinVerificationState = .loading
            let request = WithdrawalRequest(addressID: addressID,
                                            amount: amount,
                                            traceID: UUID().uuidString.lowercased(),
                                            pin: pin,
                                            memo: "")
            self.api.withdrawal.withdrawal(withdrawal: request) { result in
                switch result {
                case .success(let snapshot):
                    let assetItem = self.assetItems.first(where: { $0.asset.id == snapshot.assetID })
                    let snapshotItem = SnapshotItem(snapshot: snapshot, assetItem: assetItem)
                    
                    var snapshots = self.snapshots[snapshot.assetID] ?? []
                    snapshots.insert(snapshotItem, at: 0)
                    self.snapshots[snapshot.assetID] = snapshots
                    
                    self.pinVerificationState = .success
                    onSuccess()
                case let .failure(error):
                    self.pinVerificationState = .failure(error)
                }
            }
        }
        pinVerificationState = .waiting
        pinVerificationCaption = "Withdraw"
        isPINVerificationPresented = true
    }
    
}
