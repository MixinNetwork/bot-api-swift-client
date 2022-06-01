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
        .custom("DINCondensed-Bold", size: size, relativeTo: .body)
    }
    
}
