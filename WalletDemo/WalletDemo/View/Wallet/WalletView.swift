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
                List {
                    Section {
                        headerView
                    }
                    Section {
                        assetsView
                    }
                }
                .refreshable {
                    await withCheckedContinuation { continuation in
                        viewModel.reloadAssets {
                            continuation.resume()
                        }
                    }
                }
            }
        }
        .navigationTitle("Wallet")
    }
    
    @ViewBuilder
    private var headerView: some View {
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
    
    @ViewBuilder
    private var assetsView: some View {
        ForEach(viewModel.visibleAssetItems) { item in
            NavigationLink {
                AssetView(item: item)
            } label: {
                HStack {
                    AssetIconView(icon: item.icon)
                        .frame(width: 44, height: 44)
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
    
    private func reloadAssets() {
        viewModel.reloadAssets(completion: nil)
    }
    
}
