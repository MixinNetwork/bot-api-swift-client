//
//  Ed25519PrivateKey.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/3.
//

import Foundation
import CryptoKit

public class Ed25519PrivateKey {
    
    let rawRepresentation: Data
    let x25519Representation: Data
    let publicKey: Ed25519PublicKey
    
    private let key: Curve25519.Signing.PrivateKey
    
    public convenience init() {
        let key = Curve25519.Signing.PrivateKey()
        self.init(key: key)
    }
    
    public convenience init(rawRepresentation: Data) throws {
        let key = try Curve25519.Signing.PrivateKey(rawRepresentation: rawRepresentation)
        self.init(key: key)
    }
    
    init(key: Curve25519.Signing.PrivateKey) {
        let rawRepresentation = key.rawRepresentation
        self.rawRepresentation = rawRepresentation
        self.x25519Representation = Self.x25519(from: rawRepresentation)
        self.publicKey = Ed25519PublicKey(key: key.publicKey)!
        self.key = key
    }
    
    func signature(for data: Data) throws -> Data {
        try key.signature(for: data)
    }
    
}

extension Ed25519PrivateKey {
    
    private static func x25519(from ed25519: Data) -> Data {
        let hash = SHA512.hash(data: ed25519)
        var x25519 = Data(hash)
        x25519[0] &= 248;
        x25519[31] &= 127;
        x25519[31] |= 64;
        return x25519.prefix(32)
    }
    
}
