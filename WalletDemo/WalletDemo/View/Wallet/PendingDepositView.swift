//
//  PendingDepositView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/7/8.
//

import SwiftUI
import MixinAPI

struct PendingDepositView: View {
    
    let asset: AssetItem
    let deposit: PendingDepositItem
    
    var body: some View {
        List {
            Section {
                VStack {
                    HStack {
                        Spacer()
                        AssetIconView(icon: asset.icon)
                            .frame(width: 70, height: 70)
                        Spacer()
                    }
                    HStack {
                        Text(deposit.deposit.amount)
                            .font(.dinCondensed(ofSize: 34))
                            .foregroundColor(Color(.secondaryLabel))
                        Text(asset.asset.symbol)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
                .padding()
            }
            
            SnapshotInfoSection(header: "Transaction ID", content: deposit.deposit.transactionID)
            SnapshotInfoSection(header: "Transaction Hash", content: deposit.deposit.transactionHash)
            SnapshotInfoSection(header: "Sender", content: deposit.deposit.sender)
            SnapshotInfoSection(header: "Confirmation", content: "\(deposit.deposit.confirmations)")
            SnapshotInfoSection(header: "Threshold", content: "\(deposit.deposit.threshold)")
            SnapshotInfoSection(header: "Date", content: deposit.date)
        }
        .navigationTitle("Pending Deposit")
    }
    
}
