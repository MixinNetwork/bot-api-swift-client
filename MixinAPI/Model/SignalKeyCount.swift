//
//  SignalKeyCount.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/9.
//

import Foundation

public struct SignalKeyCount {
    
    public let preKeyCount: Int
    
}

extension SignalKeyCount: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case preKeyCount = "one_time_pre_keys_count"
    }
    
}
