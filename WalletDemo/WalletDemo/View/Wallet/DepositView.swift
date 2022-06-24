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
            List {
                DepositSectionView(value: item.asset.destination, header: "Address")
                if !item.asset.tag.isEmpty {
                    DepositSectionView(value: item.asset.tag, header: item.asset.id == AssetID.ripple ? "Tag" : "Memo")
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

extension DepositView {
    
    fileprivate struct DepositSectionView: View {
        
        let value: String
        let header: String
        
        var body: some View {
            Section {
                Text(value)
                    .font(.callout.monospaced())
                    .padding(.vertical, 8)
                Button {
                    UIPasteboard.general.string = value
                } label: {
                    HStack {
                        Spacer()
                        Text("Copy")
                        Spacer()
                    }
                }
            } header: {
                Text(header)
            }
        }
        
    }
    
}

struct DepositSectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            DepositView.DepositSectionView(value: "0xABCDEFGHIJKLMNOPQRSTUVWXYZ", header: "Address")
            DepositView.DepositSectionView(value: "Memo31415926", header: "Memo")
        }
    }
    
}
