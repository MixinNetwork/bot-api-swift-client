//
//  LogResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/6.
//

import Foundation

public struct LogResponse {
    
    public let logID: String
    public let code: String
    public let ipAddress: String
    public let createdAt: String
    
}

extension LogResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case logID = "log_id"
        case code = "code"
        case ipAddress = "ip_address"
        case createdAt = "created_at"
    }
    
}
