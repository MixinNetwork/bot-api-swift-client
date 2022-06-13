//
//  AssetView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/31.
//

import SwiftUI

struct AssetView: View {
    
    let item: AssetItem
    
    @State private var action: Action?
    @State private var isActionActive = false
    
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
                AssetHeaderView(item: item)
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
            
            Section {
                ForEach(viewModel.snapshots[item.asset.id] ?? []) { item in
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
                        viewModel.loadSnapshots(assetID: item.asset.id)
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
        .navigationTitle(item.asset.name)
        .onAppear {
            viewModel.loadSnapshotsIfEmpty(assetID: item.asset.id)
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
                Color(.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                Text(content)
                    .foregroundColor(.accentColor)
            }
        }
        
    }
    
}
