//
//  AssetIcon.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/1.
//

import Foundation

struct AssetIcon {
    
    static let none = AssetIcon(asset: nil, chain: nil)
    
    let asset: URL?
    let chain: URL?
    
}
