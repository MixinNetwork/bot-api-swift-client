//
//  AckMessage.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct AckMessage {
    
    public let jobId: String
    public let messageId: String
    public let status: String
    
}

extension AckMessage: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case status
    }
    
}
