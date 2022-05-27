//
//  ConsoleOutput.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/9.
//

import Foundation
import MixinAPI

class ConsoleOutput: Analytic {
    
    func log(level: LogLevel, category: StaticString, message: String, userInfo: [String : Any]?) {
        print("[\(level)][\(category)]\(message)")
    }
    
    func report(error: Error) {
        print("Report: \(error)")
    }
    
}
