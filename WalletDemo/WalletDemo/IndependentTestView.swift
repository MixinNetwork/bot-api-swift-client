//
//  IndependentTestView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/4/28.
//

import SwiftUI
import MixinAPI

struct IndependentTestView: View {
    
    private let api: API
    
    @State private var isResultPresented = false
    @State private var result = ""
    
    var body: some View {
        List {
            Section {
                Button("/authorizations") {
                    api.authorize.authorizations { result in
                        self.result = "\(result)"
                        self.isResultPresented = true
                    }
                }
            } header: {
                Text("Authorization")
            }
        }
        .navigationTitle("Independent Test")
        .alert(isPresented: $isResultPresented, content: {
            Alert(title: Text("Response"),
                  message: Text(result),
                  dismissButton: .default(Text("OK")))
        })
    }
    
    init(session: API.Session) {
        self.api = API(session: session)
    }
    
}
