//
//  AddressPickerView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/2.
//

import SwiftUI

struct AddressPickerView: View {
    
    let assetItem: AssetItem
    
    @EnvironmentObject private var viewModel: WalletViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            switch viewModel.addressesState[assetItem.asset.id] {
            case .waiting, .none:
                ProgressView()
                    .scaleEffect(2)
                    .onAppear {
                        viewModel.loadAddress(assetID: assetItem.asset.id)
                    }
            case .loading:
                ProgressView()
                    .scaleEffect(2)
            case .failure(let error):
                ErrorView(error: error) {
                    viewModel.loadAddress(assetID: assetItem.asset.id)
                }
            case .success:
                Group {
                    if addresses.isEmpty {
                        Text("No available address. Tap + on top right to add one.")
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            .font(.body)
                    } else {
                        List(addresses) { item in
                            NavigationLink {
                                WithdrawView(assetItem: assetItem, addressItem: item)
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(item.address.label)
                                            .font(.callout)
                                        Spacer()
                                        Text(item.date)
                                            .font(.caption)
                                            .foregroundColor(Color(.secondaryLabel))
                                    }
                                    Text(item.address.destination)
                                        .font(.subheadline.monospaced())
                                        .foregroundColor(Color(.secondaryLabel))
                                }
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            }
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.deleteAddress(address: item.address, assetID: self.assetItem.id)
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                .toolbar {
                    NavigationLink {
                        NewAddressView(item: assetItem)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationTitle(assetItem.asset.symbol + " Address")
    }
    
    private var addresses: [AddressItem] {
        viewModel.addresses[assetItem.asset.id] ?? []
    }
    
}
