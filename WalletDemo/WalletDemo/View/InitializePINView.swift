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
        NavigationView {
            content
        }
        .interactiveDismissDisabled(true)
    }
    
    @ViewBuilder
    var content: some View {
        VStack {
            Text("Initialize PIN")
                .font(.largeTitle)
            Text("You must intialize a PIN to access you wallet fully-functional")
                .multilineTextAlignment(.center)
                .padding(8)
            Spacer()
        }
    }
    
}

struct InitializePINView_Previews: PreviewProvider {
    
    static var previews: some View {
        InitializePINView()
    }
    
}
