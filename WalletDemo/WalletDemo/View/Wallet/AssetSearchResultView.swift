//
//  AssetSearchResultView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import SwiftUI

struct AssetSearchResultView: View {
    
    @EnvironmentObject var viewModel: WalletViewModel
    
    var body: some View {
        switch viewModel.assetSearchState {
        case .none:
            EmptyView()
        case .loading:
            ProgressView()
                .scaleEffect(2)
        case .success(let items):
            if items.isEmpty {
                Text("NO RESULTS")
            } else {
                List(items) { item in
                    AssetCell(item: item)
                }
            }
        case .failure(let error):
            Text(error.localizedDescription)
                .padding()
        }
    }
    
}
