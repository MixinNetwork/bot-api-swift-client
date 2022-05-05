//
//  WalletHost.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/4.
//

import Foundation
import MixinAPI
import SwiftUI

class WalletHost {
    
    @AppStorage("host", store: .standard)
    private var hostIndex: Int = 0
    
}

extension WalletHost: HostStorage {
    
    func index() -> Int {
        hostIndex
    }
    
    func save(index: Int) {
        hostIndex = index
    }
    
}
