//
//  SessionSecretUpdateResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/6.
//

import Foundation

public struct SessionSecretUpdateResponse {
    
    public let pinToken: String
    
}

extension SessionSecretUpdateResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case pinToken = "pin_token"
    }
    
}
