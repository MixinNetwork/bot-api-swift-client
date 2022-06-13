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
                    VStack(alignment: .center, spacing: 8) {
                        HStack(alignment: .top, spacing: 2) {
                            Spacer()
                            Text("$")
                                .font(.body)
                                .foregroundColor(Color(.secondaryLabel))
                            Text(viewModel.usdBalance)
                                .font(.dinCondensed(ofSize: 40))
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text(viewModel.btcBalance)
                                .font(.dinCondensed(ofSize: 15))
                            Text("BTC")
                                .font(.caption)
                                .foregroundColor(Color(.secondaryLabel))
                            Spacer()
                        }
                    }.padding(16)
                }
                Section {
                    ForEach(viewModel.assetItems) { item in
                        NavigationLink {
                            AssetView(item: item)
                        } label: {
                            HStack {
                                AssetIconView(icon: item.icon)
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(maxHeight: 44)
                                VStack {
                                    HStack {
                                        Text(item.balance)
                                            .font(.dinCondensed(ofSize: 19))
                                        Text(item.asset.symbol)
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text(item.change)
                                            .font(.subheadline)
                                            .foregroundColor(item.isChangePositive ? .green : .red)
                                    }
                                    HStack {
                                        Text("≈ " + item.usdBalance)
                                            .font(.caption)
                                            .foregroundColor(Color(.secondaryLabel))
                                        Spacer()
                                        Text(item.usdPrice)
                                            .font(.caption)
                                            .foregroundColor(Color(.secondaryLabel))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
