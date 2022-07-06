//
//  WalletDemoApp.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/4/28.
//

import SwiftUI
import SDWebImage
import MixinAPI

@main
struct WalletDemoApp: App {
    
    @StateObject private var viewModel: AccountViewModel
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.result {
            case let .success((api, account)):
                HomeView(api: api, account: account)
            case let .failure(error):
                switch error {
                case MixinError.unauthorized:
                    VStack {
                        Image(systemName: "person.fill.questionmark")
                            .font(.system(size: 48))
                            .padding()
                        Text("Unauthorized session\nCheck if credential is valid")
                            .multilineTextAlignment(.center)
                    }
                case TransportError.clockSkewDetected:
                    VStack {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 48))
                            .padding()
                        Text("Clock skew detected\nCheck your time settings before reload")
                            .multilineTextAlignment(.center)
                        Button("Reload", action: viewModel.reloadAccount)
                            .tint(.accentColor)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .buttonBorderShape(.roundedRectangle)
                            .padding()
                    }
                default:
                    ErrorView(error: error, action: viewModel.reloadAccount)
                }
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
        viewModel.reloadAccount()
    }
    
}
