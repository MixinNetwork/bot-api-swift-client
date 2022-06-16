//
//  WalletView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/27.
//

import SwiftUI
import MixinAPI

struct WalletView: View {
    
    @EnvironmentObject var viewModel: WalletViewModel
    
    @State private var keyword = ""
    
    var body: some View {
        Group {
            switch viewModel.reloadAssetsState {
            case let .failure(error):
                ErrorView(error: error, action: reloadAssets)
            case .waiting:
                ProgressView()
                    .scaleEffect(2)
                    .onAppear(perform: reloadAssets)
            case .loading where viewModel.visibleAssetItems.isEmpty:
                ProgressView()
                    .scaleEffect(2)
            default:
                WalletContentView()
            }
        }
        .navigationTitle("Wallet")
        .searchable(text: $keyword, prompt: "Search")
        .disableAutocorrection(true)
        .onSubmit(of: .search) {
            viewModel.search(keyword: keyword)
        }
    }
    
    private func reloadAssets() {
        viewModel.reloadAssets(completion: nil)
    }
    
}
