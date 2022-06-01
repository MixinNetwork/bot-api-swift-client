//
//  AssetView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/31.
//

import SwiftUI

struct AssetView: View {
    
    let item: AssetItem
    
    @EnvironmentObject private var wallet: WalletViewModel
    
    var body: some View {
        List {
            Section {
                AssetHeaderView(item: item)
            }
            
            Section {
                HStack(alignment: .center, spacing: 12) {
                    Button {
                        
                    } label: {
                        Color(.systemBackground)
                            .overlay(Text("SEND"))
                            .cornerRadius(10)
                    }
                    Button {
                        
                    } label: {
                        Color(.systemBackground)
                            .overlay(Text("RECEIVE"))
                            .cornerRadius(10)
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
