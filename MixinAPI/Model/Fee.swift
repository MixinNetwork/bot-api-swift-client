//
//  Fee.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct Fee {
    
    public let type: String
    public let assetID: String
    public let amount: String
    
}

extension Fee: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case assetID = "asset_id"
        case amount
    }
    
}
