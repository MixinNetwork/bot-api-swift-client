//
//  SignalKeyRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/9.
//

import Foundation

public struct SignalKeyRequest {
    
    public let identityKey: String
    public let signedPreKey: SignedPreKeyRequest
    public let oneTimePreKeys: [OneTimePreKey]?
    
}

extension SignalKeyRequest: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case identityKey = "identity_key"
        case signedPreKey = "signed_pre_key"
        case oneTimePreKeys = "one_time_pre_keys"
    }
    
}
