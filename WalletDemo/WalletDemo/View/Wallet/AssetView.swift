//
//  AssetView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/31.
//

import SwiftUI

struct AssetView: View {
    
    let item: AssetItem
    
    // Workaround SwiftUI's bug on multiple NavigationLinks inside a List
    // Confirmed on iOS 15.1
    @State private var action: Action = .send
    @State private var isActionActive = false
    
    @EnvironmentObject private var wallet: WalletViewModel
    
    var body: some View {
        NavigationLink(isActive: $isActionActive) {
            switch action {
            case .send:
                DepositView(item: item)
            case .receive:
                DepositView(item: item)
            }
        } label: {
            EmptyView()
        }
        
        List {
            Section {
                AssetHeaderView(item: item)
            }
            
            Section {
                HStack(alignment: .center, spacing: 12) {
                    Button {
                        action = .send
                        isActionActive = true
                    } label: {
                        ActionButtonLabel(content: "SEND")
                    }
                    Button {
                        action = .receive
                        isActionActive = true
                    } label: {
                        ActionButtonLabel(content: "RECEIVE")
                    }
                }
                .frame(height: 60)
            }
            .listRowInsets(EdgeInsets(.zero))
            .listRowBackground(Color(.systemGroupedBackground))
            
            Section {
                ForEach(wallet.snapshots[item.asset.id] ?? []) { item in
                    NavigationLink {
                        SnapshotView(item: item)
                    } label: {
                        HStack {
                            Text(item.type)
                                .font(.system(size: 14))
                            Spacer()
                            Text(item.amount)
                                .font(.dinCondensed(ofSize: 19))
                                .foregroundColor(item.isAmountPositive ? .green : .red)
                            Text(item.assetSymbol)
                                .font(.system(size: 12, weight: .medium))
                        }
                    }
                }
                switch wallet.snapshotsState[item.asset.id] {
                case .waiting:
                    Button("Load More") {
                        wallet.loadSnapshots(assetID: item.asset.id)
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
            }
        }
        .navigationTitle(item.asset.name)
        .onAppear {
            wallet.loadSnapshotsIfEmpty(assetID: item.asset.id)
        }
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
                Color(.secondarySystemBackground)
                    .cornerRadius(10)
                Text(content)
                    .foregroundColor(.accentColor)
            }
        }
        
    }
    
}
