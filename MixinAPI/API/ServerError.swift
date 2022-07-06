//
//  ServerError.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/7/6.
//

import Foundation

public protocol ServerError: Error {
    
    var isUnauthorized: Bool { get }
    
}
