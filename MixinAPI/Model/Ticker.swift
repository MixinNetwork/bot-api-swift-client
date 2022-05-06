//
//  Ticker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct Ticker {
    
    public let priceUsd: String
    
}

extension Ticker: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case priceUsd = "price_usd"
    }
    
}
