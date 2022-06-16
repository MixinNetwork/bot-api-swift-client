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
    
    private var account: Account
    
    @StateObject private var walletViewModel: WalletViewModel
    
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
                .environmentObject(walletViewModel)
                
                NavigationView {
                    SwapView()
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Swap", systemImage: "cart")
                }
                .environmentObject(SwapViewModel())
            }
            .zIndex(0)
            
            if walletViewModel.isPINVerificationPresented {
                VerifyPINView()
                    .ignoresSafeArea()
                    .zIndex(2)
            }
        }
        .sheet(isPresented: $isPINAbsent) {
            InitializePINView()
        }
    }
    
    init(api: API, account: Account) {
        self.api = api
        self.account = account
        self._walletViewModel = StateObject(wrappedValue: WalletViewModel(api: api))
        self.isPINAbsent = !account.hasPIN
    }
    
}
