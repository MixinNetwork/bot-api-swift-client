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
    
    var body: some View {
        switch viewModel.assetsState {
        case let .failure(error):
            VStack {
                Button("Reload", action: viewModel.reloadAssets)
                Text(error.localizedDescription)
            }
        case .waiting:
            ProgressView()
                .scaleEffect(2)
                .onAppear(perform: viewModel.reloadAssets)
        case .loading:
            ProgressView()
                .scaleEffect(2)
        case .success:
            List {
                Section {
                    WalletHeaderView()
                }
                Section {
                    ForEach(viewModel.assetItems) { item in
                        NavigationLink {
                            AssetView(item: item)
                        } label: {
                            WalletCell(item: item)
                        }
                    }
                }
            }
        }
    }
    
}
