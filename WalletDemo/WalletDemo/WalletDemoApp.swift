//
//  WalletDemoApp.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/4/28.
//

import SwiftUI

@main
struct WalletDemoApp: App {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.result {
            case let .success((api, account)):
                HomeView(api: api, account: account)
            default:
                NavigationView {
                    LoginView(viewModel: viewModel)
                }
            }
        }
    }
    
}
