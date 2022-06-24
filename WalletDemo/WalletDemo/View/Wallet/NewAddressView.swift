//
//  NewAddressView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/2.
//

import SwiftUI

struct NewAddressView: View {
    
    private enum Field {
        case label
        case address
        case memo
    }
    
    let item: AssetItem
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var viewModel: WalletViewModel
    
    @FocusState private var focusedField: Field?
    
    @State private var label = ""
    @State private var address = ""
    @State private var needsMemo = true
    @State private var memo = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Label", text: $label)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .keyboardType(.asciiCapable)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .label)
                        .onSubmit {
                            focusedField = .address
                        }
                    Image(systemName: "doc.on.clipboard")
                        .foregroundColor(Color(.secondaryLabel))
                        .onTapGesture {
                            if let string = UIPasteboard.general.string {
                                label = string
                            }
                        }
                }
            }
            Section {
                HStack {
                    TextField("Address", text: $address)
                        .multilineTextAlignment(.leading)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .address)
                        .onSubmit {
                            focusedField = .memo
                        }
                    Image(systemName: "doc.on.clipboard")
                        .foregroundColor(Color(.secondaryLabel))
                        .onTapGesture {
                            if let string = UIPasteboard.general.string {
                                address = string
                            }
                        }
                }
            }
            Section {
                Toggle("Requires Memo", isOn: $needsMemo)
                if needsMemo {
                    HStack {
                        TextField("Memo", text: $memo)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .submitLabel(.done)
                            .focused($focusedField, equals: .memo)
                            .onSubmit {
                                focusedField = nil
                            }
                        Image(systemName: "doc.on.clipboard")
                            .foregroundColor(Color(.secondaryLabel))
                            .onTapGesture {
                                if let string = UIPasteboard.general.string {
                                    memo = string
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("New \(item.asset.symbol) Address")
        .toolbar {
            Button("Save") {
                focusedField = nil
                viewModel.saveAddress(assetID: item.asset.id,
                                      label: label,
                                      address: address,
                                      memo: memo,
                                      onSuccess: dismiss.callAsFunction)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                self.focusedField = .label
            }
        }
    }
    
}
