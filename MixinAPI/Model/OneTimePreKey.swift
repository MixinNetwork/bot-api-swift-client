//
//  OneTimePreKey.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/9.
//

import Foundation

public struct OneTimePreKey {
    
    public let keyId: UInt32
    public let preKey: String?
    
    public init(keyId: UInt32, preKey: Data) {
        self.keyId = keyId
        self.preKey = preKey.base64EncodedString()
    }
    
}

extension OneTimePreKey: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case keyId = "key_id"
        case preKey = "pub_key"
    }
    
}
