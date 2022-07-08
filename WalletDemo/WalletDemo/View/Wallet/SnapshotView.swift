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
            
            SnapshotInfoSection(header: "Transaction ID", content: item.id)
            SnapshotInfoSection(header: "Asset Name", content: item.assetName)
            SnapshotInfoSection(header: "Opponent ID", content: item.snapshot.opponentID)
            SnapshotInfoSection(header: "Memo", content: item.snapshot.memo)
            SnapshotInfoSection(header: "Date", content: item.date)
        }
        .navigationTitle("Transaction")
    }
    
}
