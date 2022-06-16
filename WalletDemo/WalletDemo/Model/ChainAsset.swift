//
//  ChainAsset.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/16.
//

import Foundation

struct ChainAsset: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case iconURL = "iconUrl"
    }
    
    let id: String
    let symbol: String
    let name: String
    let iconURL: URL
    
}
