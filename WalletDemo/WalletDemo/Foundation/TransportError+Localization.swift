//
//  TransportError+Localization.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/24.
//

import Foundation
import MixinAPI

extension TransportError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidPath(let path):
            return "Invalid path: \(path)"
        case .taskFailed(let error):
            return "Task failed: \(error.localizedDescription)"
        case .invalidStatusCode(let code):
            return "Invalid status code: \(code)"
        case .invalidResponse(let response):
            return "Invalid response: \(response?.description ?? "(null)")"
        case .noData(let response):
            return "No data: \(response)"
        case .buildURLRequest(let error):
            return "Failed to build request: \(error)"
        case .invalidJSON(let error):
            return "Invalid JSON: \(error)"
        case .pinEncryption(let error):
            return "Failed to encrypt PIN: \(error)"
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
