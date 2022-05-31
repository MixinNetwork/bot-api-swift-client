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
        switch viewModel.result {
        case let .success(representation):
            List {
                Section {
                    VStack(alignment: .center, spacing: 8) {
                        HStack(alignment: .top, spacing: 2) {
                            Spacer()
                            Text("$")
                                .font(.system(size: 18))
                                .foregroundColor(Color(.secondaryLabel))
                            Text(representation.fiatMoneyBalance)
                                .font(.dinCondensed(ofSize: 40))
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text(representation.btcBalance)
                                .font(.dinCondensed(ofSize: 14))
                            Text("BTC")
                                .font(.caption)
                                .foregroundColor(Color(.secondaryLabel))
                            Spacer()
                        }
                    }.padding(16)
                }
                Section {
                    ForEach(representation.assets) { viewModel in
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
                                    Text("≈ " + viewModel.usdBalance)
                                        .font(.caption)
                                        .foregroundColor(Color(.secondaryLabel))
                                    Spacer()
                                    Text(viewModel.usdPrice)
                                        .font(.caption)
                                        .foregroundColor(Color(.secondaryLabel))
                                }
                            }
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
