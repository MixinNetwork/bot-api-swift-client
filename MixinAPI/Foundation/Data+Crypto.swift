//
//  AESCryptor.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/30.
//

import Foundation

extension Data {
    
    init?(withNumberOfSecuredRandomBytes count: Int) {
        guard let bytes = malloc(count) else {
            return nil
        }
        let status = SecRandomCopyBytes(kSecRandomDefault, count, bytes)
        guard status == errSecSuccess else {
            return nil
        }
        self.init(bytesNoCopy: bytes, count: count, deallocator: .free)
    }
    
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
}
