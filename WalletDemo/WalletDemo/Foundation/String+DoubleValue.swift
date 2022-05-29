//
//  String+DoubleValue.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import Foundation

extension String {
    
    // XXX: This conversion doesn't cover localization, DO NOT use it in production
    var doubleValue: Double {
        Double(self) ?? 0
    }
    
}
