//
//  AuthenticationView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/5.
//

import SwiftUI
import MixinAPI

struct AuthenticationView: UIViewControllerRepresentable {
    
    let authentication: Authentication
    
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> AuthenticationViewController {
        AuthenticationViewController(authentication: authentication, isPresented: $isPresented)
    }
    
    func updateUIViewController(_ uiViewController: AuthenticationViewController, context: Context) {
        
    }
    
}
