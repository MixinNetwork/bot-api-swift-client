//
//  MixinError.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/29.
//

import Foundation

public enum MixinError: ServerError {
    
    case unknown(status: Int, code: Int, description: String)
    
    case invalidRequestBody
    case unauthorized
    case forbidden
    case notFound
    case tooManyRequests
    
    case internalServerError
    
    case invalidRequestData(field: String?)
    case requiresUpdate
    case insufficientBalance
    case malformedPIN
    case incorrectPIN
    case transferAmountTooSmall
    case expiredAuthorizationCode
    case insufficientFee
    case transferIsAlreadyPaid
    case withdrawAmountTooSmall
    case malformedWithdrawalMemo
    
    case chainNotInSync
    case malformedAddress
    case insufficientPool
    
    public var isUnauthorized: Bool {
        switch self {
        case .unauthorized:
            return true
        default:
            return false
        }
    }
    
    private init(status: Int, code: Int, description: String, extra: Extra?) {
        switch (status, code) {
        case (202, 400):
            self = .invalidRequestBody
        case (202, 401):
            self = .unauthorized
        case (202, 403):
            self = .forbidden
        case (202, 404):
            self = .notFound
        case (202, 429):
            self = .tooManyRequests
            
        case (500, 500):
            self = .internalServerError
            
        case (202, 10002):
            self = .invalidRequestData(field: extra?.field)
        case (202, 10006):
            self = .requiresUpdate
        case (202, 20117):
            self = .insufficientBalance
        case (202, 20118):
            self = .malformedPIN
        case (202, 20119):
            self = .incorrectPIN
        case (202, 20120):
            self = .transferAmountTooSmall
        case (202, 20121):
            self = .expiredAuthorizationCode
        case (202, 20124):
            self = .insufficientFee
        case (202, 20125):
            self = .transferIsAlreadyPaid
        case (202, 20127):
            self = .withdrawAmountTooSmall
        case (202, 20131):
            self = .malformedWithdrawalMemo
            
        case (202, 30100):
            self = .chainNotInSync
        case (202, 30102):
            self = .malformedAddress
        case (202, 30103):
            self = .insufficientPool
            
        default:
            self = .unknown(status: status, code: code, description: description)
        }
    }
    
}

extension MixinError: Decodable {
    
    enum CodingKeys: CodingKey {
        case code
        case status
        case description
        case extra
    }
    
    private struct Extra: Decodable {
        let field: String?
        let reason: String?
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(Int.self, forKey: .status)
        let code = try container.decode(Int.self, forKey: .code)
        let description = try container.decode(String.self, forKey: .description)
        let extra = try container.decodeIfPresent(Extra.self, forKey: .extra)
        self.init(status: status, code: code, description: description, extra: extra)
    }
    
}
