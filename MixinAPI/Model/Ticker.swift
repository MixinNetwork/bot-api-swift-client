//
//  Ticker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct Ticker {
    
    public let usdPrice: String
    
}

extension Ticker: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case usdPrice = "price_usd"
    }
    
}
