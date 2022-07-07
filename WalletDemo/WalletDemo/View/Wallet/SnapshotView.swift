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
                    HStack {
                        Spacer()
                        AssetIconView(icon: item.assetIcon)
                            .frame(width: 70, height: 70)
                        Spacer()
                    }
                    HStack {
                        Text(item.amount)
                            .font(.dinCondensed(ofSize: 34))
                            .foregroundColor(item.isAmountPositive ? .green : .red)
                        Text(item.assetSymbol)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    Text("≈ " + item.usdAmount)
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding()
            }
            
            InfoSection(header: "Transaction ID", content: item.id)
            InfoSection(header: "Asset Name", content: item.assetName)
            InfoSection(header: "Opponent ID", content: item.snapshot.opponentID)
            InfoSection(header: "Memo", content: item.snapshot.memo)
            InfoSection(header: "Date", content: item.date)
        }
        .navigationTitle("Transaction")
    }
    
}

extension SnapshotView {
    
    private struct InfoSection: View {
        
        let header: String
        let content: String?
        
        var body: some View {
            if let content = content, !content.isEmpty {
                Section {
                    Text(content)
                        .font(.callout.monospaced())
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                } header: {
                    Text(header)
                }
            } else {
                EmptyView()
            }
        }
        
    }
    
}
