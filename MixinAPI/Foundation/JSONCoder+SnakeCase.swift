//
//  JSONCoder+SnakeCase.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/2.
//

import Foundation

extension JSONEncoder {
    
    static let snakeCase: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
}

extension JSONDecoder {
    
    static let snakeCase: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
}
