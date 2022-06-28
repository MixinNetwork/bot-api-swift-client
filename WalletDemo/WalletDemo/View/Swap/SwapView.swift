//
//  SwapView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/27.
//

import SwiftUI

struct SwapView: View {
    
    @EnvironmentObject private var swapViewModel: SwapViewModel
    @EnvironmentObject private var walletViewModel: WalletViewModel
    
    @FocusState private var isAmountFocused: Bool
    
    @State private var amount = ""
    @State private var decimalAmount: Decimal?
    @State private var isAmountLegal = false
    @State private var pickerTarget: SwapAssetPickerView.Target = .payment
    @State private var isPickerPresented = false
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            switch swapViewModel.swappableAssets {
            case .waiting, .loading:
                ProgressView()
                    .scaleEffect(2)
            case .failed(let error):
                ErrorView(error: error) {
                    Task {
                        await swapViewModel.reloadSwappableAssets()
                    }
                }
            case .success(let assets):
                let paymentAsset = assets[swapViewModel.selectedPaymentAssetIndex]
                let paymentAssetItem = walletViewModel.allAssetItems[paymentAsset.id]!
                let settlementAsset = assets[swapViewModel.selectedSettlementAssetIndex]
                let settlementAssetItem = walletViewModel.allAssetItems[settlementAsset.id]!
                VStack {
                    List {
                        Section {
                            HStack {
                                HStack {
                                    AssetIconView(icon: paymentAssetItem.icon)
                                        .frame(width: 24, height: 24)
                                    Text(paymentAssetItem.asset.symbol)
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
                                    .keyboardType(.decimalPad)
                                    .focused($isAmountFocused)
                                    .onChange(of: amount) { amount in
                                        if let amount = decimalAmount {
                                            isAmountLegal = amount <= paymentAsset.maxQuoteAmount && amount >= paymentAsset.minQuoteAmount
                                        } else {
                                            isAmountLegal = false
                                        }
                                    }
                            }
                        } header: {
                            Text("Pay")
                                .font(.headline)
                        } footer: {
                            HStack {
                                Button {
                                    amount = paymentAssetItem.asset.balance
                                } label: {
                                    HStack {
                                        Text("Balance: " + paymentAssetItem.balance)
                                            .foregroundColor(Color(.secondaryLabel))
                                        Image(systemName: "arrow.up.right.circle")
                                            .tint(Color(.label))
                                    }
                                }
                                Spacer()
                                if isAmountLegal, let amount = paymentUSDAmount(item: paymentAssetItem) {
                                    Text("≈ " + amount)
                                } else {
                                    Text("Amount between \(paymentAsset.minQuoteAmountString) and \(paymentAsset.maxQuoteAmountString)")
                                }
                            }
                        }
                        .textCase(nil)
                        
                        Section {
                            HStack {
                                HStack {
                                    AssetIconView(icon: settlementAssetItem.icon)
                                        .frame(width: 24, height: 24)
                                    Text(settlementAssetItem.asset.symbol)
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
                                Text(receivedAmount(paymentItem: paymentAssetItem, settlementItem: settlementAssetItem))
                                    .foregroundColor(Color(.secondaryLabel))
                                    .multilineTextAlignment(.trailing)
                            }
                        } header: {
                            Text("Receive")
                                .font(.headline)
                        }
                        .textCase(nil)
                        
                        Button {
                            Task {
                                let estimatedSettlementAmount = receivedAmount(paymentItem: paymentAssetItem,
                                                                               settlementItem: settlementAssetItem)
                                await swapViewModel.createPayment(quoteAssetID: paymentAsset.id,
                                                                  quoteAmount: amount,
                                                                  settlementAssetID: settlementAsset.id,
                                                                  estimatedSettlementAmount: estimatedSettlementAmount)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                if swapViewModel.isCreatingPayment || walletViewModel.isAuthenticationPresented {
                                    ProgressView()
                                } else {
                                    Text("Swap")
                                }
                                Spacer()
                            }
                        }
                        .tint(.accentColor)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .buttonBorderShape(.roundedRectangle)
                        .disabled(!isAmountLegal)
                        .listRowInsets(EdgeInsets(.zero))
                        .listRowBackground(Color.clear)
                        
                        if !swapViewModel.traces.isEmpty {
                            Section {
                                ForEach(swapViewModel.traces) { trace in
                                    HStack {
                                        Text(trace.caption)
                                        Spacer()
                                        switch trace.status {
                                        case .unpaid, .pending:
                                            ProgressView()
                                        case .success:
                                            Image(systemName: "checkmark.circle")
                                                .foregroundColor(.green)
                                        case .failed:
                                            Image(systemName: "xmark.circle")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            } header: {
                                Text("Payments")
                            }
                        }
                    }
                }
            }
        }
        .disabled(swapViewModel.isCreatingPayment || walletViewModel.isAuthenticationPresented)
        .navigationTitle("Swap")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        isAmountFocused = false
                    }
                }
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            SwapAssetPickerView(target: pickerTarget)
        }
        .onChange(of: amount) { amount in
            decimalAmount = Decimal(string: amount)
        }
        .task {
            await swapViewModel.reloadSwappableAssets()
        }
    }
    
    private func paymentUSDAmount(item: AssetItem) -> String? {
        guard let decimalAmount = decimalAmount else {
            return nil
        }
        let amount = decimalAmount * item.decimalUSDPrice
        return CurrencyFormatter.localizedString(from: amount, format: .fiatMoney, sign: .never, symbol: .usd)
    }
    
    private func receivedAmount(paymentItem: AssetItem, settlementItem: AssetItem) -> String {
        if let decimalAmount = decimalAmount {
            let amount = decimalAmount * paymentItem.decimalUSDPrice / settlementItem.decimalUSDPrice
            return CurrencyFormatter.localizedString(from: amount, format: .precision, sign: .never)
        } else {
            return "Estimated Amount"
        }
    }
    
}
