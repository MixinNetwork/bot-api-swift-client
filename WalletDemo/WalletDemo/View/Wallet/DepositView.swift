//
//  DepositView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import SwiftUI

struct DepositView: View {
    
    @State private var item: AssetItem
    
    @EnvironmentObject private var viewModel: WalletViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if let state = viewModel.assetItemsState[item.asset.id] {
                switch state {
                case .waiting, .success:
                    destinationLoadingContentView
                case .loading:
                    ProgressView()
                        .scaleEffect(2)
                case .failure(let error):
                    ErrorView(error: error, action: reloadAsset)
                }
            } else {
                destinationLoadingContentView
            }
        }
        .navigationTitle("Deposit " + item.asset.symbol)
    }
    
    @ViewBuilder
    private var destinationLoadingContentView: some View {
        if item.asset.destination.isEmpty {
            ProgressView()
                .scaleEffect(2)
                .onAppear(perform: reloadAsset)
        } else {
            contentView
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        List {
            Section {
                Text(item.asset.destination)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .swipeActions {
                        Button("Copy") {
                            UIPasteboard.general.string = item.asset.destination
                        }
                        .tint(.accentColor)
                    }
            } header: {
                Text("Address")
            }
            
            if !item.asset.tag.isEmpty {
                Section {
                    Text(item.asset.tag)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .swipeActions {
                            Button("Copy") {
                                UIPasteboard.general.string = item.asset.tag
                            }
                            .tint(.accentColor)
                        }
                } header: {
                    Text(item.asset.id == AssetID.ripple ? "Tag" : "Memo")
                }
            }
        }
    }
    
    init(item: AssetItem) {
        self._item = State(initialValue: item)
    }
    
    private func reloadAsset() {
        viewModel.reloadAsset(with: item.asset.id) { item in
            if let item = item {
                self.item = item
            }
        }
    }
    
}
