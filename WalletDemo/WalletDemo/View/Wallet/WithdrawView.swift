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
                
                if !viewModel.isPINVerificationPresented {
                    Button("Withdraw") {
                        viewModel.withdraw(amount: amount,
                                           toAddressWith: address.id,
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

struct WithdrawView_Previews: PreviewProvider {
    
    static let assetItem: AssetItem = {
        let iconURL = URL(string: "https://mixin-images.zeromesh.net/HvYGJsV5TGeZ-X9Ek3FEQohQZ3fE9LBEBGcOcn4c4BNHovP4fW4YB97Dg5LcXoQ1hUjMEgjbl1DPlKg1TW7kK6XP=s128")
        let asset = Asset(assetID: "c6d0c728-2624-429b-8e0d-d9d19b6592fa",
                          type: "asset",
                          symbol: "BTC",
                          name: "Bitcoin",
                          iconURL: iconURL!.absoluteString,
                          balance: "10",
                          destination: "",
                          tag: "",
                          btcPrice: "1",
                          usdPrice: "50399",
                          usdChange: "-0.010717440376877024",
                          chainID: "c6d0c728-2624-429b-8e0d-d9d19b6592fa",
                          confirmations: 3,
                          assetKey: "c6d0c728-2624-429b-8e0d-d9d19b6592fa",
                          reserve: "")
        return AssetItem(asset: asset, chainIconURL: iconURL)
    }()
    
    static let addressItem: AddressItem = {
        let address = Address(id: "",
                              type: "address",
                              assetID: "c6d0c728-2624-429b-8e0d-d9d19b6592fa",
                              destination: "",
                              label: "",
                              tag: "",
                              fee: "0.01",
                              reserve: "0.01",
                              dust: "0.0001",
                              updatedAt: "2018-09-29T07:10:59.699476845Z")
        return AddressItem(address: address)
    }()
    
    static var previews: some View {
        WithdrawView(assetItem: assetItem, addressItem: addressItem)
    }
    
}
