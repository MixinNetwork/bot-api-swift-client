//
//  MixinError+Localization.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/24.
//

import Foundation
import MixinAPI

extension MixinError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .unknown(status, code, _):
            return "Unknown error status: \(status), code: \(code)"
        default:
            let spaced = String(describing: self)
                .replacingOccurrences(of: "([a-z])([A-Z](?=[A-Z])[a-z]*)", with: "$1 $2", options: .regularExpression)
                .replacingOccurrences(of: "([A-Z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
                .replacingOccurrences(of: "([a-z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
                .replacingOccurrences(of: "([a-z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
            return spaced.prefix(1).capitalized + spaced.dropFirst()
        }
    }
    
}
