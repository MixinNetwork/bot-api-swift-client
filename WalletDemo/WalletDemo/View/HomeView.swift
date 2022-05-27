//
//  HomeView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/27.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            TabView {
                WalletView()
                    .tabItem {
                        Label("Wallet", systemImage: "creditcard")
                    }
                MarketView()
                    .tabItem {
                        Label("Market", systemImage: "cart")
                    }
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
    
}
