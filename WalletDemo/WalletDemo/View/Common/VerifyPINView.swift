//
//  VerifyPINView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/5.
//

import SwiftUI
import MixinAPI

struct VerifyPINView: UIViewControllerRepresentable {
    
    @EnvironmentObject var viewModel: WalletViewModel
    
    func makeUIViewController(context: Context) -> VerifyPINViewController {
        VerifyPINViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: VerifyPINViewController, context: Context) {
        
    }
    
}
