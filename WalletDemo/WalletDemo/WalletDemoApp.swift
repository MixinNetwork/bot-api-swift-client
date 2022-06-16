//
//  WalletDemoApp.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/4/28.
//

import SwiftUI
import SDWebImage

@main
struct WalletDemoApp: App {
    
    @StateObject private var viewModel: AccountViewModel
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.result {
            case let .success((api, account)):
                HomeView(api: api, account: account)
            case let .failure(error):
                ErrorView(error: error, action: viewModel.loadAccount)
            case .none:
                ProgressView()
                    .scaleEffect(2)
            }
        }
    }
    
    init() {
        SDImageCache.shared.config.maxDiskAge = -1
        let viewModel = AccountViewModel()
        self._viewModel = StateObject(wrappedValue: viewModel)
        viewModel.loadAccount()
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
}
