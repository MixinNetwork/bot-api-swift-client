//
//  RequestOptions.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/7/6.
//

import Foundation

struct RequestOptions: OptionSet {
    
    static let authIndependent = RequestOptions(rawValue: 1 << 0)
    static let disableRetryOnRequestSigningTimeout = RequestOptions(rawValue: 1 << 1)
    
    let rawValue: UInt
    
    init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}
