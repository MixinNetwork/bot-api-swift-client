//
//  SwapAssetPickerView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import SwiftUI

struct SwapAssetPickerView: View {
    
    enum Target {
        case payment
        case settlement
    }
    
    let target: Target
    
    @EnvironmentObject var viewModel: SwapViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        switch viewModel.swappableAssets {
        case .success(let assets):
            VStack {
                Group {
                    switch target {
                    case .payment:
                        Text("Payment Asset")
                    case .settlement:
                        Text("Settlement Asset")
                    }
                }
                .font(.headline)
                .padding(.top, 20)
                
                List(assets) { asset in
                    Button {
                        if let index = assets.firstIndex(where: { $0.id == asset.id }) {
                            switch target {
                            case .payment:
                                viewModel.selectedPaymentAssetIndex = index
                            case .settlement:
                                viewModel.selectedSettlementAssetIndex = index
                            }
                        }
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            Group {
                                switch target {
                                case .payment:
                                    if asset.id == assets[viewModel.selectedPaymentAssetIndex].id {
                                        Image(systemName: "checkmark")
                                    } else {
                                        Spacer()
                                    }
                                case .settlement:
                                    if asset.id == assets[viewModel.selectedSettlementAssetIndex].id {
                                        Image(systemName: "checkmark")
                                    } else {
                                        Spacer()
                                    }
                                }
                            }
                            .frame(width: 18)
                            AssetIconView(icon: asset.icon)
                                .frame(width: 44, height: 44)
                            Text(asset.symbol)
                                .foregroundColor(Color(.label))
                        }
                    }
                }
            }
        default:
            EmptyView()
        }
        
    }
    
}
