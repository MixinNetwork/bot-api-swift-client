//
//  OneTimePreKey.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/9.
//

import Foundation

public struct OneTimePreKey {
    
    public let keyID: UInt32
    public let preKey: String?
    
    public init(keyID: UInt32, preKey: Data) {
        self.keyID = keyID
        self.preKey = preKey.base64EncodedString()
    }
    
}

extension OneTimePreKey: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case keyID = "key_id"
        case preKey = "pub_key"
    }
    
}
