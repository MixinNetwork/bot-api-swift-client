//
//  CategoriesView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/4/28.
//

import SwiftUI
import MixinAPI

struct CategoriesView: View {
    
    let api: API
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
    
    init(session: API.Session) {
        self.api = API(session: session)
    }
    
}
