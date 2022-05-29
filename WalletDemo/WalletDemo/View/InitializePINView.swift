//
//  InitializePINView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/28.
//

import SwiftUI

struct InitializePINView: View {
    
    @State private var pin = ""
    
    var body: some View {
        SecureField("PIN", text: $pin)
            .accentColor(.clear)
    }
    
}
