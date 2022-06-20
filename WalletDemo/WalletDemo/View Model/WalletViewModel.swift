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
    
    enum SearchAssetState {
        case loading(Request)
        case success([AssetItem])
        case failure(Error)
    }
    
    enum SnapshotState {
        case waiting
        case loading(Request)
        case reachedEnd
        case failure(Error)
    }
    
    private let api: API
    private let assetComparator = AssetValueSortComparator()
    private let snapshotLimit = 30
    private let fixedAssetIDs: Set<String> = [
        AssetID.bitcoin,
        AssetID.ethereum,
        AssetID.usdtEthereum,
        AssetID.doge,
    ]
    
    @Published private(set) var reloadAssetsState: State = .waiting
    @Published private(set) var visibleAssetItems: [AssetItem] = []
    @Published private(set) var usdBalance: String = ""
    @Published private(set) var btcBalance: String = ""
    private(set) var allAssetItems: [String: AssetItem] = [:]
    
    @Published private(set) var assetSearchState: SearchAssetState? = nil
    
    // Key is Asset ID
    @Published private(set) var assetItemsState: [String: State] = [:]
    
    // Key is Asset ID
    @Published private(set) var snapshots: [String: [SnapshotItem]] = [:]
    @Published private(set) var snapshotsState: [String: SnapshotState] = [:]
    
    // Key is Asset ID
    @Published private(set) var addresses: [String: [AddressItem]] = [:]
    @Published private(set) var addressesState: [String: State] = [:]
    
    @Published var isAuthenticationPresented = false
    @Published var authentication: Authentication?
    
    init(api: API) {
        self.api = api
    }
    
    func clearSearchResults() {
        if case let .loading(request) = assetSearchState {
            request.cancel()
        }
        assetSearchState = nil
    }
    
    private func visibleAssetItems(from items: [AssetItem]) -> [AssetItem] {
        items.filter { item in
            if fixedAssetIDs.contains(item.asset.id) {
                return true
            } else {
                return item.decimalBalance > 0
            }
        }.sorted(using: assetComparator)
    }
    
    private func insert(assets: [Asset]) {
        assert(Thread.isMainThread)
        let items: [AssetItem] = assets.map { asset in
            let chainIconURL: URL?
            if asset.id == asset.chainID {
                chainIconURL = URL(string: asset.iconURL)
            } else if let chain = allAssetItems[asset.chainID] {
                chainIconURL = URL(string: chain.asset.iconURL)
            } else if let chain = assets.first(where: { $0.id == asset.chainID }) {
                chainIconURL = URL(string: chain.iconURL)
            } else {
                chainIconURL = nil
            }
            return AssetItem(asset: asset, chainIconURL: chainIconURL)
        }
        for item in items {
            allAssetItems[item.asset.id] = item
        }
        visibleAssetItems = visibleAssetItems(from: Array(allAssetItems.values))
    }
    
}

// MARK: - PIN
extension WalletViewModel {
    
    func initializePIN(onSuccess: @escaping (Account) -> Void) {
        authentication = Authentication(title: "Initialize PIN", operation: .initialize) { pin, report in
            report(.loading)
            self.api.account.updatePIN(old: nil, new: pin) { result in
                switch result {
                case .success(let account):
                    onSuccess(account)
                    report(.success)
                case .failure(let error):
                    report(.failure(error))
                }
            }
        }
        isAuthenticationPresented = true
    }
    
}

// MARK: - Asset
extension WalletViewModel {
    
    func reloadAssets(completion: (() -> Void)?) {
        if case .loading = reloadAssetsState {
            completion?()
            return
        }
        reloadAssetsState = .loading
        let api = self.api
        api.asset.assets(queue: .global()) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.reloadAssetsState = .failure(error)
                    completion?()
                }
            case .success(var assets):
                var missingAssetIDs = self.fixedAssetIDs
                missingAssetIDs.formUnion(assets.map(\.chainID))
                missingAssetIDs.subtract(assets.map(\.id))
                for id in missingAssetIDs {
                    let result = api.asset.asset(assetID: id)
                    switch result {
                    case let .success(asset):
                        assets.append(asset)
                    case let .failure(error):
                        DispatchQueue.main.async {
                            self.reloadAssetsState = .failure(error)
                        }
                        return
                    }
                }
                DispatchQueue.main.async {
                    self.insert(assets: assets)
                    let (totalUSDBalance, totalBTCBalance) = self.visibleAssetItems.reduce((0, 0)) { partialResult, asset in
                        (partialResult.0 + asset.decimalUSDBalance, partialResult.1 + asset.decimalBTCBalance)
                    }
                    self.usdBalance = CurrencyFormatter.localizedString(from: totalUSDBalance, format: .fiatMoney, sign: .never)
                    self.btcBalance = CurrencyFormatter.localizedString(from: totalBTCBalance, format: .precision, sign: .never)
                    self.reloadAssetsState = .success
                    completion?()
                }
            }
        }
    }
    
    func reloadAsset(with id: String, completion: ((AssetItem?) -> Void)? = nil) {
        if case .loading = reloadAssetsState {
            completion?(nil)
            return
        }
        if case .loading = assetItemsState[id] {
            completion?(nil)
            return
        }
        assetItemsState[id] = .loading
        api.asset.asset(assetID: id) { result in
            switch result {
            case .success(let asset):
                self.insert(assets: [asset])
                self.assetItemsState[id] = .success
                completion?(self.allAssetItems[id])
            case .failure(let error):
                self.assetItemsState[id] = .failure(error)
                completion?(nil)
            }
        }
    }
    
    func search(keyword: String) {
        if case let .loading(request) = assetSearchState {
            request.cancel()
        }
        let request = api.asset.search(keyword: keyword) { result in
            switch result {
            case .success(let assets):
                self.insert(assets: assets)
                let items = assets.compactMap { asset in
                    self.allAssetItems[asset.id]
                }
                self.assetSearchState = .success(items)
            case .failure(let error):
                self.assetSearchState = .failure(error)
            }
        }
        assetSearchState = .loading(request)
    }
    
}

// MARK: - Snapshot
extension WalletViewModel {
    
    func reloadSnapshotsIfEmpty(assetID: String) {
        if let snapshots = snapshots[assetID], !snapshots.isEmpty {
            return
        }
        reloadSnapshots(assetID: assetID)
    }
    
    func reloadSnapshots(assetID: String, completion: (() -> Void)? = nil) {
        if case let .loading(request) = snapshotsState[assetID] {
            request.cancel()
        }
        let limit = self.snapshotLimit
        let request = api.asset.snapshots(limit: limit, offset: nil, assetID: assetID) { result in
            switch result {
            case .success(let snapshots):
                let items: [SnapshotItem] = snapshots.map { snapshot in
                    let item = self.allAssetItems[snapshot.assetID]
                    return SnapshotItem(snapshot: snapshot, assetItem: item)
                }
                self.snapshots[assetID] = items
                self.snapshotsState[assetID] = snapshots.count < limit ? .reachedEnd : .waiting
            case .failure(let error):
                self.snapshotsState[assetID] = .failure(error)
            }
            completion?()
        }
        snapshotsState[assetID] = .loading(request)
    }
    
    func loadMoreSnapshotsIfNeeded(assetID: String) {
        switch snapshotsState[assetID] {
        case .loading, .reachedEnd:
            return
        case .waiting, .failure, .none:
            break
        }
        let limit = self.snapshotLimit
        let currentSnapshots = snapshots[assetID] ?? []
        let offset = currentSnapshots.last?.snapshot.createdAt
        let request = api.asset.snapshots(limit: limit, offset: offset, assetID: assetID) { result in
            switch result {
            case .success(let snapshots):
                let items: [SnapshotItem] = snapshots.map { snapshot in
                    let item = self.allAssetItems[snapshot.assetID]
                    return SnapshotItem(snapshot: snapshot, assetItem: item)
                }
                self.snapshots[assetID] = currentSnapshots + items
                self.snapshotsState[assetID] = snapshots.count < limit ? .reachedEnd : .waiting
            case .failure(let error):
                self.snapshotsState[assetID] = .failure(error)
            }
        }
        snapshotsState[assetID] = .loading(request)
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
        let fields = [
            Authentication.Field(title: "Label", description: label),
            Authentication.Field(title: "Address", description: address),
        ]
        authentication = Authentication(title: "Add Address", operation: .verify(confirmation: fields)) { (pin, report) in
            report(.loading)
            let request = AddressRequest(assetID: assetID, destination: address, tag: memo, label: label, pin: pin)
            self.api.withdrawal.save(address: request) { result in
                switch result {
                case let .success(address):
                    let item = AddressItem(address: address)
                    var addresses = self.addresses[assetID] ?? []
                    addresses.append(item)
                    self.addresses[assetID] = addresses
                    report(.success)
                    onSuccess()
                case let .failure(error):
                    report(.failure(error))
                }
            }
        }
        isAuthenticationPresented = true
    }
    
    func deleteAddress(address: Address, assetID: String) {
        let fields = [
            Authentication.Field(title: "Label", description: address.label),
            Authentication.Field(title: "Destination", description: address.destination),
        ]
        authentication = Authentication(title: "Delete Address", operation: .verify(confirmation: fields)) { (pin, report) in
            report(.loading)
            self.api.withdrawal.delete(addressID: address.id, pin: pin) { result in
                switch result {
                case .success:
                    self.addresses[assetID]?.removeAll(where: { item in
                        item.address.id == address.id
                    })
                    report(.success)
                case let .failure(error):
                    report(.failure(error))
                }
            }
        }
        isAuthenticationPresented = true
    }
    
}

// MARK: - Withdraw
extension WalletViewModel {
    
    func withdraw(amount: String, symbol: String, to address: Address, onSuccess: @escaping () -> Void) {
        let fields = [
            Authentication.Field(title: "Amount", description: "\(amount) \(symbol)"),
            Authentication.Field(title: "Address", description: address.label),
            Authentication.Field(title: "Destination", description: address.destination),
        ]
        authentication = Authentication(title: "Withdraw", operation: .verify(confirmation: fields)) { (pin, report) in
            report(.loading)
            let request = WithdrawalRequest(addressID: address.id,
                                            amount: amount,
                                            traceID: UUID().uuidString.lowercased(),
                                            pin: pin,
                                            memo: "")
            self.api.withdrawal.withdrawal(withdrawal: request) { result in
                switch result {
                case .success(let snapshot):
                    self.reloadAsset(with: snapshot.assetID)
                    self.reloadSnapshots(assetID: snapshot.assetID)
                    report(.success)
                    onSuccess()
                case let .failure(error):
                    report(.failure(error))
                }
            }
        }
        isAuthenticationPresented = true
    }
    
    func swap(payment: SwapPayment, onSuccess: @escaping () -> Void) {
        let fields = [
            Authentication.Field(title: "Pay", description: "\(payment.paymentAmount) \(payment.paymentAssetSymbol)"),
            Authentication.Field(title: "Est. Receive", description: "\(payment.estimatedSettlementAmount) \(payment.settlementAssetSymbol)"),
            Authentication.Field(title: "Trace ID", description: "\(payment.traceID)"),
            Authentication.Field(title: "Expire At", description: DateFormatter.general.string(from: payment.expire)),
        ]
        authentication = Authentication(title: "Swap", operation: .verify(confirmation: fields)) { (pin, report) in
            report(.loading)
            self.api.payment.transfer(assetID: payment.paymentAssetID,
                                      opponentID: payment.recipient,
                                      amount: payment.paymentAmount,
                                      memo: payment.memo,
                                      pin: pin,
                                      traceID: payment.traceID) { result in
                switch result {
                case .success(let snapshot):
                    self.reloadAsset(with: snapshot.assetID)
                    self.reloadSnapshots(assetID: snapshot.assetID)
                    report(.success)
                    onSuccess()
                case let .failure(error):
                    report(.failure(error))
                }
            }
        }
        isAuthenticationPresented = true
    }
    
}
