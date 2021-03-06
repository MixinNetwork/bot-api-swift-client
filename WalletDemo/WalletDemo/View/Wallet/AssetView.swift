//
//  AssetView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/31.
//

import SwiftUI
import MixinAPI

struct AssetView: View {
    
    @State private var action: Action?
    @State private var isActionActive = false
    @State private var item: AssetItem
    
    @EnvironmentObject private var viewModel: WalletViewModel
    
    var body: some View {
        NavigationLink(isActive: $isActionActive) {
            switch action {
            case .send:
                AddressPickerView(assetItem: item)
            case .receive:
                DepositView(item: item)
            case .none:
                EmptyView()
            }
        } label: {
            EmptyView()
        }
        
        List {
            Section {
                HStack(alignment: .center, spacing: 8) {
                    AssetIconView(icon: item.icon)
                        .frame(width: 50, height: 50)
                    VStack {
                        HStack {
                            Text(item.asset.balance)
                                .font(.dinCondensed(ofSize: 34))
                            Text(item.asset.symbol)
                                .font(.caption)
                            Spacer()
                        }
                        HStack {
                            Text("≈ " + item.usdBalance)
                                .font(.footnote)
                                .fontWeight(.light)
                                .foregroundColor(Color(.secondaryLabel))
                            Spacer()
                        }
                    }
                }
                .frame(minHeight: 100)
            }
            
            Section {
                HStack(alignment: .center, spacing: 12) {
                    ActionButtonLabel(content: "SEND")
                        .onTapGesture {
                            action = .send
                            isActionActive = true
                        }
                    ActionButtonLabel(content: "RECEIVE")
                        .onTapGesture {
                            action = .receive
                            isActionActive = true
                        }
                }
                .frame(height: 60)
            }
            .listRowInsets(EdgeInsets(.zero))
            .listRowBackground(Color(.systemGroupedBackground))
            
            switch viewModel.pendingDeposits[item.asset.id] {
            case .success(let items):
                if items.isEmpty {
                    EmptyView()
                } else {
                    Section {
                        ForEach(items) { item in
                            GeometryReader { geometry in
                                ZStack {
                                    HStack {
                                        Color(.quaternaryLabel)
                                            .frame(width: geometry.size.width * item.progress)
                                        Spacer()
                                    }
                                    
                                    NavigationLink {
                                        PendingDepositView(asset: self.item, deposit: item)
                                    } label: {
                                        HStack {
                                            Text("Confirming (\(item.deposit.confirmations)/\(item.deposit.threshold))")
                                                .font(.subheadline)
                                            Spacer()
                                            Text(item.deposit.amount)
                                                .font(.dinCondensed(ofSize: 19))
                                                .foregroundColor(Color(.secondaryLabel))
                                            Text(self.item.asset.symbol)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .listRowInsets(EdgeInsets(.zero))
                        }
                    } header: {
                        Text("Pending Deposits")
                    }
                }
            case .failure:
                Section {
                    Button("Reload") {
                        viewModel.reloadPendingDeposits(assetID: item.asset.id)
                    }
                } header: {
                    Text("Pending Deposits")
                }
            case .loading, .none:
                Section {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } header: {
                    Text("Pending Deposits")
                }
            }
            
            if showTransactionSection {
                Section {
                    ForEach(snapshots) { item in
                        NavigationLink {
                            SnapshotView(item: item)
                        } label: {
                            HStack {
                                Text(item.type)
                                    .font(.subheadline)
                                Spacer()
                                Text(item.amount)
                                    .font(.dinCondensed(ofSize: 19))
                                    .foregroundColor(item.isAmountPositive ? .green : .red)
                                Text(item.assetSymbol)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    switch viewModel.snapshotsState[item.asset.id] {
                    case .waiting:
                        Button("Load More") {
                            viewModel.loadMoreSnapshotsIfNeeded(assetID: item.asset.id)
                        }
                    case .reachedEnd:
                        EmptyView()
                    case .none, .loading:
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .failure(let error):
                        Text(error.localizedDescription)
                    }
                } header: {
                    Text("Transactions")
                }
            }
        }
        .navigationTitle(item.asset.name)
        .onAppear {
            viewModel.reloadSnapshotsIfEmpty(assetID: item.asset.id)
            viewModel.reloadPendingDeposits(assetID: item.asset.id)
        }
        .refreshable {
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                viewModel.reloadAsset(with: item.asset.id) { item in
                    if let item = item {
                        self.item = item
                    }
                    continuation.resume()
                }
            }
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                viewModel.reloadSnapshots(assetID: item.asset.id) {
                    continuation.resume()
                }
            }
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                viewModel.reloadPendingDeposits(assetID: item.asset.id) {
                    continuation.resume()
                }
            }
        }
    }
    
    private var snapshots: [SnapshotItem] {
        viewModel.snapshots[item.asset.id] ?? []
    }
    
    private var showTransactionSection: Bool {
        switch viewModel.snapshotsState[item.asset.id] {
        case .reachedEnd:
            return !snapshots.isEmpty
        default:
            return true
        }
    }
    
    init(item: AssetItem) {
        self._item = State(initialValue: item)
    }
    
}

extension AssetView {
    
    private enum Action {
        case send, receive
    }
    
    private struct ActionButtonLabel: View {
        
        let content: String
        
        var body: some View {
            ZStack {
                Color(.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                Text(content)
                    .foregroundColor(.accentColor)
            }
        }
        
    }
    
}
