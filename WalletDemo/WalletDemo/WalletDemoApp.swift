//
//  WalletDemoApp.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/4/28.
//

import SwiftUI

@main
struct WalletDemoApp: App {
    
    @StateObject private var viewModel: AccountViewModel
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.result {
            case let .success((api, account)):
                HomeView(api: api, account: account)
            case let .failure(error):
                VStack {
                    Button("Retry", action: viewModel.loadAccount)
                        .buttonStyle(RoundedBackgroundButtonStyle())
                    Text(error.localizedDescription)
                }
            case .none:
                ProgressView()
                    .scaleEffect(2)
            }
        }
    }
    
    init() {
        let viewModel = AccountViewModel()
        self._viewModel = StateObject(wrappedValue: viewModel)
        viewModel.loadAccount()
    }
    
}
