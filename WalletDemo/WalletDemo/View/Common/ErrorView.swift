//
//  ErrorView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    
    let error: Error
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button("Reload", action: action)
                .tint(.accentColor)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .buttonBorderShape(.roundedRectangle)
                .padding()
            Text(error.localizedDescription)
        }
    }
    
}
