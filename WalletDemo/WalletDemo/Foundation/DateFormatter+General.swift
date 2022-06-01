//
//  DateFormatter+General.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import Foundation

extension DateFormatter {
    
    static let general: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter
    }()
    
}
