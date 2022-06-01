//
//  DepositView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import SwiftUI

struct DepositView: View {
    
    let item: AssetItem
    
    var body: some View {
        List {
            Section {
                Text(item.asset.destination)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .swipeActions {
                        Button("Copy") {
                            UIPasteboard.general.string = item.asset.destination
                        }
                        .tint(.accentColor)
                    }
            } header: {
                Text("Address")
            }
            
            if !item.asset.tag.isEmpty {
                Section {
                    Text(item.asset.tag)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .swipeActions {
                            Button("Copy") {
                                UIPasteboard.general.string = item.asset.tag
                            }
                            .tint(.accentColor)
                        }
                } header: {
                    Text(item.asset.id == AssetID.ripple ? "Tag" : "Memo")
                }
            }
        }
        .navigationTitle("Deposit " + item.asset.symbol)
    }
    
}
