//
//  AddressPickerView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/2.
//

import SwiftUI

struct AddressPickerView: View {
    
    let item: AssetItem
    
    @EnvironmentObject private var viewModel: WalletViewModel
    
    var body: some View {
        contentView
            .navigationTitle(item.asset.symbol + " Address")
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.addressesState[item.asset.id] {
        case .waiting, .none:
            ProgressView()
                .scaleEffect(2)
                .onAppear {
                    viewModel.loadAddress(assetID: item.asset.id)
                }
        case .loading:
            ProgressView()
                .scaleEffect(2)
        case .failure(let error):
            VStack {
                Button("Retry") {
                    viewModel.loadAddress(assetID: item.asset.id)
                }
                .buttonStyle(RoundedBackgroundButtonStyle())
                Text(error.localizedDescription)
            }
        case .success:
            addressList
                .toolbar {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
        }
    }
    
    @ViewBuilder
    private var addressList: some View {
        if addresses.isEmpty {
            Text("No available address. Tap + on top right to add one.")
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .font(.body)
        } else {
            List(addresses) { item in
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
        }
    }
    
    private var addresses: [AddressItem] {
        viewModel.addresses[item.asset.id] ?? []
    }
    
}
