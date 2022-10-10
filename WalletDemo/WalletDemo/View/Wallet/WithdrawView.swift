//
//  WithdrawView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/13.
//

import SwiftUI
import MixinAPI

struct WithdrawView: View {
    
    let assetItem: AssetItem
    let addressItem: AddressItem
    
    @State private var amount = ""
    
    @FocusState private var isAmountFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var viewModel: WalletViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                List {
                    Section {
                        HStack {
                            AssetIconView(icon: assetItem.icon)
                                .frame(width: 44, height: 44)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(asset.name)
                                Text(asset.balance + " " + asset.symbol)
                                    .font(.footnote)
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                    Section {
                        VStack(alignment: .leading, spacing: 2) {
                            TextField("Amount", text: $amount)
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .disableAutocorrection(true)
                                .keyboardType(.decimalPad)
                                .focused($isAmountFocused)
                            Text(usdAmount)
                                .font(.footnote)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                    } footer: {
                        VStack(alignment: .leading, spacing: 2) {
                            Spacer(minLength: 8)
                            HStack(alignment: .center, spacing: 0) {
                                Text("Network fee: ")
                                Text(address.fee)
                                    .foregroundColor(Color(.label))
                                Text(" " + addressItem.feeSymbol)
                            }
                            if addressItem.dust > 0 {
                                HStack(alignment: .center, spacing: 0) {
                                    Text("Minimum amount: ")
                                    Text(address.dust)
                                        .foregroundColor(Color(.label))
                                }
                            }
                            if addressItem.reserve > 0 {
                                HStack(alignment: .center, spacing: 0) {
                                    Text("Minimum reserve: ")
                                    Text(address.reserve)
                                        .foregroundColor(Color(.label))
                                }
                            }
                        }
                    }
                }
                
                if !viewModel.isAuthenticationPresented {
                    Button("Withdraw") {
                        isAmountFocused = false
                        viewModel.withdraw(amount: amount,
                                           symbol: assetItem.asset.symbol,
                                           to: address,
                                           onSuccess: dismiss.callAsFunction)
                    }
                    .tint(.accentColor)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .buttonBorderShape(.capsule)
                    .padding()
                    .disabled(!isAmountValid)
                }
            }
        }
        .navigationTitle("Withdraw to \(address.label)")
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                self.isAmountFocused = true
            }
        }
    }
    
    private var asset: Asset {
        assetItem.asset
    }
    
    private var address: Address {
        addressItem.address
    }
    
    private var usdAmount: String {
        let decimal = (Decimal(string: amount) ?? 0) * assetItem.decimalUSDPrice
        let string = CurrencyFormatter.localizedString(from: decimal, format: .fiatMoney, sign: .never)
        return string + " USD"
    }
    
    private var isAmountValid: Bool {
        if let decimal = Decimal(string: amount) {
            return decimal > 0
        } else {
            return false
        }
    }
    
}
