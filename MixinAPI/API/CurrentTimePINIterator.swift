//
//  CurrentTimePINIterator.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/11.
//

import Foundation

public final class CurrentTimePINIterator: PINIterator {
    
    public init() {
        
    }
    
    public func value() -> UInt64 {
        UInt64(Date().timeIntervalSince1970 * 1000)
    }
    
}
