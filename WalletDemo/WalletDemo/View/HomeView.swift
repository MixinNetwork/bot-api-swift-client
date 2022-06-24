//
//  HomeView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/27.
//

import SwiftUI
import MixinAPI

struct HomeView: View {
    
    private let api: API
    
    @StateObject private var walletViewModel: WalletViewModel
    @StateObject private var swapViewModel: SwapViewModel
    
    @State private var account: Account
    @State private var isPINAbsent: Bool
    
    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    WalletView()
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Wallet", systemImage: "creditcard")
                }
                
                NavigationView {
                    SwapView()
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Swap", systemImage: "cart")
                }
                .environmentObject(swapViewModel)
            }
            .zIndex(0)
            
            if walletViewModel.isAuthenticationPresented, let authentication = walletViewModel.authentication {
                AuthenticationView(authentication: authentication, isPresented: $walletViewModel.isAuthenticationPresented)
                    .ignoresSafeArea()
                    .zIndex(2)
            }
            
            if let id = swapViewModel.traceID, !walletViewModel.isAuthenticationPresented {
                SwapTraceView(traceID: id) {
                    swapViewModel.traceID = nil
                }
                .environmentObject(swapViewModel)
            }
        }
        .environmentObject(walletViewModel)
        .task {
            if !account.hasPIN {
                walletViewModel.initializePIN() { account in
                    self.account = account
                }
            }
        }
    }
    
    init(api: API, account: Account) {
        let walletViewModel = WalletViewModel(api: api)
        let swapViewModel = SwapViewModel(clientID: account.userID, walletViewModel: walletViewModel)
        
        self.api = api
        self.account = account
        self._walletViewModel = StateObject(wrappedValue: walletViewModel)
        self._swapViewModel = StateObject(wrappedValue: swapViewModel)
        self.isPINAbsent = !account.hasPIN
    }
    
}
