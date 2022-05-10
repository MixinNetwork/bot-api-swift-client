//
//  AckMessage.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct AckMessage {
    
    public let jobID: String
    public let messageID: String
    public let status: String
    
}

extension AckMessage: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case messageID = "message_id"
        case status
    }
    
}
