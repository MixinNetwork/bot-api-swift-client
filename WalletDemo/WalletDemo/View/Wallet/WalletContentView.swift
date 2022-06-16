//
//  WalletContentView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import SwiftUI

struct WalletContentView: View {
    
    @EnvironmentObject var viewModel: WalletViewModel
    
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        Group {
            if isSearching {
                AssetSearchResultView()
            } else {
                MyAssetsView()
            }
        }
        .onChange(of: isSearching) { _ in
            viewModel.clearSearchResults()
        }
    }
    
}
