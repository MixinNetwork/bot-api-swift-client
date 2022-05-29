//
//  RoundedBackgroundButtonStyle.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/28.
//

import Foundation
import SwiftUI

struct RoundedBackgroundButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(12)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
}
