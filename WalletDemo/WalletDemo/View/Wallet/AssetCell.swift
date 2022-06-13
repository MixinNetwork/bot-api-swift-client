//
//  AssetCell.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import SwiftUI

struct WalletCell: View {
    
    let item: AssetItem
    
    var body: some View {
        HStack {
            AssetIconView(icon: item.icon)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: 44)
            VStack {
                HStack {
                    Text(item.balance)
                        .font(.dinCondensed(ofSize: 19))
                    Text(item.asset.symbol)
                        .font(.footnote)
                        .fontWeight(.medium)
                    Spacer()
                    Text(item.change)
                        .font(.subheadline)
                        .foregroundColor(item.isChangePositive ? .green : .red)
                }
                HStack {
                    Text("≈ " + item.usdBalance)
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                    Spacer()
                    Text(item.usdPrice)
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
        }
    }
    
}