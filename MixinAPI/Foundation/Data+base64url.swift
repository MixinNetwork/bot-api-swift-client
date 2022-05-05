//
//  AESCryptor.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/30.
//

import Foundation

extension Data {
    
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
}
