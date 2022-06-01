//
//  WalletHeaderView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import SwiftUI

struct WalletHeaderView: View {
    
    @EnvironmentObject var viewModel: WalletViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .top, spacing: 2) {
                Spacer()
                Text("$")
                    .font(.body)
                    .foregroundColor(Color(.secondaryLabel))
                Text(viewModel.usdBalance)
                    .font(.dinCondensed(ofSize: 40))
                Spacer()
            }
            HStack {
                Spacer()
                Text(viewModel.btcBalance)
                    .font(.dinCondensed(ofSize: 15))
                Text("BTC")
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                Spacer()
            }
        }.padding(16)
    }
    
}
