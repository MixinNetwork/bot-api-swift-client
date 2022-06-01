//
//  AssetHeaderView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import SwiftUI

struct AssetHeaderView: View {
    
    let item: AssetItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            AssetIconView(icon: item.icon)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: 50)
            VStack {
                HStack {
                    Text(item.asset.balance)
                        .font(.dinCondensed(ofSize: 34))
                    Text(item.asset.symbol)
                        .font(.system(size: 12))
                    Spacer()
                }
                HStack {
                    Text("≈ " + item.usdBalance)
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(.secondaryLabel))
                    Spacer()
                }
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "info.circle")
            }
        }
    }
    
}
