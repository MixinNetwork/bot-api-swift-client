//
//  JWT.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/4.
//

import Foundation

enum JWT {
    
    struct Claims: Encodable {
        let uid: String
        let sid: String
        let iat: Date
        let exp: Date
        let jti: String
        let sig: String
        let scp: String
    }
    
    enum Error: Swift.Error {
        case signAlgorithmNotSupported
        case payloadBuilding
        case sign(underlying: Swift.Error?)
    }
    
    private static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom({ (date, encoder) in
            let timeInterval = UInt64(date.timeIntervalSince1970)
            var container = encoder.singleValueContainer()
            try container.encode(timeInterval)
        })
        return encoder
    }()
    
    private static let header = #"{"alg":"EdDSA","typ":"JWT"}"#.data(using: .utf8)!.base64URLEncodedString()
    
    static func token(claims: Claims, key: Ed25519PrivateKey) throws -> String {
        let base64EncodedClaims = try jsonEncoder.encode(claims).base64URLEncodedString()
        let headerAndPayload = header + "." + base64EncodedClaims
        guard let dataToSign = headerAndPayload.data(using: .utf8) else {
            throw Error.payloadBuilding
        }
        let signature = try key.signature(for: dataToSign)
        let base64EncodedSignature = signature.base64URLEncodedString()
        return headerAndPayload + "." + base64EncodedSignature
    }
    
}
