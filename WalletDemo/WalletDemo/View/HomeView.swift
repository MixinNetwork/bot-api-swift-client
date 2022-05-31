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
        TabView {
            NavigationView {
                WalletView()
                    .navigationTitle("Wallet")
            }
            .tabItem {
                Label("Wallet", systemImage: "creditcard")
            }
            NavigationView {
                SwapView()
                    .navigationTitle("Swap")
            }
            .tabItem {
                Label("Swap", systemImage: "cart")
            }
        }
        .environmentObject(walletViewModel)
//        .sheet(isPresented: $isPINAbsent) {
//            InitializePINView()
//        }
    }
    
    init(api: API, account: Account) {
        self.api = api
        self.account = account
        self._walletViewModel = StateObject(wrappedValue: WalletViewModel(api: api))
        self.isPINAbsent = !account.hasPIN
    }
    
}
