//
//  SnapshotView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import SwiftUI

struct SnapshotView: View {
    
    let item: SnapshotItem
    
    var body: some View {
        List {
            Section {
                VStack {
                    AssetIconView(icon: item.assetIcon)
                        .frame(height: 70)
                    HStack {
                        Text(item.amount)
                            .font(.dinCondensed(ofSize: 34))
                            .foregroundColor(item.isAmountPositive ? .green : .red)
                        Text(item.assetSymbol)
                            .font(.system(size: 12, weight: .medium))
                    }
                    Text("≈ " + item.usdAmount)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding()
            }
            
            Section {
                Text(item.id)
                    .font(.system(.callout))
            } header: {
                Text("ID")
            }
            
            if let id = item.snapshot.opponentID {
                Section {
                    Text(id)
                        .font(.system(.callout))
                } header: {
                    Text("Opponent ID")
                }
            }
            
            if let hash = item.snapshot.transactionHash {
                Section {
                    Text(hash)
                        .font(.system(.callout))
                } header: {
                    Text("Transaction Hash")
                }
            }
            
            if let sender = item.snapshot.sender {
                Section {
                    Text(sender)
                        .font(.system(.callout))
                } header: {
                    Text("Sender")
                }
            }
            
            if let receiver = item.snapshot.receiver {
                Section {
                    Text(receiver)
                        .font(.system(.callout))
                } header: {
                    Text("Receiver")
                }
            }
            
            if let memo = item.snapshot.memo {
                Section {
                    Text(memo)
                        .font(.system(.callout))
                } header: {
                    Text("Memo")
                }
            }
            
            if let id = item.snapshot.traceID {
                Section {
                    Text(id)
                        .font(.system(.callout))
                } header: {
                    Text("Trace ID")
                }
            }
            
            Section {
                Text(item.date)
                    .font(.system(.callout))
            } header: {
                Text("Date")
            }
        }
        .navigationTitle("Transaction")
    }
    
}
