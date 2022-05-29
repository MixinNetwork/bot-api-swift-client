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
        switch viewModel.assets {
        case let .success(assets):
            List(assets) { viewModel in
                HStack {
                    AssetIconView(viewModel: viewModel)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxHeight: 44)
                    VStack {
                        HStack {
                            Text(viewModel.balance)
                                .font(.dinCondensed(ofSize: 19))
                            Text(viewModel.symbol)
                                .font(.system(size: 14, weight: .medium, design: .default))
                            Spacer()
                            Text(viewModel.change)
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundColor(viewModel.isChangePositive ? .green : .red)
                        }
                        HStack {
                            Text(viewModel.fiatMoneyBalance)
                                .font(.caption)
                                .foregroundColor(Color(.secondaryLabel))
                            Spacer()
                            Text(viewModel.fiatMoneyPrice)
                                .font(.caption)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                    }
                }
            }
        case let .failure(error):
            VStack {
                Button("Reload", action: viewModel.reloadAssets)
                Text(error.localizedDescription)
            }
        case .none:
            ProgressView()
                .scaleEffect(2)
                .onAppear(perform: viewModel.reloadAssets)
        }
    }
    
}
