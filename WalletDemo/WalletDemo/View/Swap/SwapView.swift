//
//  SwapView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/27.
//

import SwiftUI

struct SwapView: View {
    
    @EnvironmentObject var viewModel: SwapViewModel
    
    @State private var amount = ""
    @State private var pickerTarget: SwapAssetPickerView.Target = .payment
    @State private var isPickerPresented = false
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            switch viewModel.swappableAssets {
            case .waiting, .loading:
                ProgressView()
                    .scaleEffect(2)
            case .failed(let error):
                ErrorView(error: error) {
                    Task {
                        await viewModel.reloadSwappableAssets()
                    }
                }
            case .success(let assets):
                VStack {
                    List {
                        let paymentAsset = assets[viewModel.selectedPaymentAssetIndex]
                        Section {
                            HStack {
                                HStack {
                                    AssetIconView(icon: paymentAsset.icon)
                                        .frame(width: 24, height: 24)
                                    Text(paymentAsset.symbol)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                    Image(systemName: "chevron.down")
                                        .tint(.accentColor)
                                }
                                .foregroundColor(Color(.label))
                                .onTapGesture {
                                    pickerTarget = .payment
                                    isPickerPresented = true
                                }
                                Divider()
                                TextField("Amount", text: $amount)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.asciiCapableNumberPad)
                                    .onChange(of: amount) { newValue in
                                        // Restrict decimal
                                    }
                            }
                        } header: {
                            Text("Pay")
                                .font(.headline)
                        }
                        .textCase(nil)
                        
                        let settlementAsset = assets[viewModel.selectedSettlementAssetIndex]
                        Section {
                            HStack {
                                HStack {
                                    AssetIconView(icon: settlementAsset.icon)
                                        .frame(width: 24, height: 24)
                                    Text(settlementAsset.symbol)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                    Image(systemName: "chevron.down")
                                        .tint(.accentColor)
                                }
                                .foregroundColor(Color(.label))
                                .onTapGesture {
                                    pickerTarget = .settlement
                                    isPickerPresented = true
                                }
                                Divider()
                                Spacer()
                                Text("")
                                    .multilineTextAlignment(.trailing)
                            }
                        } header: {
                            Text("Receive")
                                .font(.headline)
                        }
                        .textCase(nil)
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Commit")
                    }
                    .tint(.accentColor)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .buttonBorderShape(.capsule)
                    .padding()
                }
            }
        }
        .navigationTitle("Swap")
        .sheet(isPresented: $isPickerPresented, content: {
            SwapAssetPickerView(target: pickerTarget)
        })
        .task {
            await viewModel.reloadSwappableAssets()
        }
    }
    
}
