//
//  Analytic.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/2.
//

import Foundation

public enum LogLevel {
    case debug
    case info
    case warning
    case error
}

public protocol Analytic {
    func log(level: LogLevel, category: StaticString, message: String, userInfo: [String: Any]?)
    func report(error: Error)
}
