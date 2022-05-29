//
//  Font+DINCondensed.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import Foundation
import SwiftUI

extension Font {
    
    static func dinCondensed(ofSize size: CGFloat) -> Font {
        if let font = UIFont(name: "DINCondensed-Bold", size: size) {
            return Font(font as CTFont)
        } else {
            return Font(UIFont.systemFont(ofSize: size, weight: .bold) as CTFont)
        }
    }
    
}
