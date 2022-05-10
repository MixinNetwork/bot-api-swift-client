//
//  PINIterator.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/6.
//

import Foundation
import SwiftUI
import MixinAPI

class PINIterator: MixinAPI.PINIterator {
    
    @AppStorage("pin_iterator", store: .standard)
    private var iteratorValue: Int = 0
    
    func value() -> UInt64 {
        iteratorValue += 1
        return UInt64(iteratorValue)
    }
    
}
