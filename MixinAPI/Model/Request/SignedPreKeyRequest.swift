//
//  SignedPreKeyRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/9.
//

import Foundation

public struct SignedPreKeyRequest {
    
    public let keyID: UInt32
    public let publicKey: String
    public let signature: String
    
    public init(keyID: UInt32, publicKey: String, signature: String) {
        self.keyID = keyID
        self.publicKey = publicKey
        self.signature = signature
    }
    
}

extension SignedPreKeyRequest: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case keyID = "key_id"
        case publicKey = "pub_key"
        case signature
    }
    
}
