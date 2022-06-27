//
//  API+AuthenticatedSession.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/4.
//

import Foundation
import CryptoKit

extension API {
    
    public class AuthenticatedSession: Session {
        
        enum Error: Swift.Error {
            case invalidURL(URL?)
            case invalidSig(String?)
        }
        
        let userID: String
        let sessionID: String
        let pinEncryptor: PINEncryptor
        let privateKey: Ed25519PrivateKey
        
        public init(
            userID: String,
            sessionID: String,
            pinToken: Data,
            privateKey: Data,
            client: Client,
            hostStorage: HostStorage,
            pinIterator: PINIterator,
            analytic: Analytic?
        ) throws {
            let privateKey = try Ed25519PrivateKey(rawRepresentation: privateKey)
            let pinEncryptionKey: Data = try {
                let privateKey = try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: privateKey.x25519Representation)
                let publicKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: pinToken)
                let agreement = try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
                return agreement.withUnsafeBytes { Data($0) }
            }()
            
            self.userID = userID
            self.sessionID = sessionID
            self.pinEncryptor = PINEncryptor(key: pinEncryptionKey,
                                             iterator: pinIterator,
                                             analytic: analytic)
            self.privateKey = privateKey
            super.init(hostStorage: hostStorage,
                       client: client,
                       analytic: analytic)
        }
        
        override func encryptPIN<Response>(_ pin: String, onFailure: @escaping (API.Result<Response>) -> Void, onSuccess: @escaping (String) -> Void) {
            pinEncryptor.encrypt(pin: pin, onFailure: onFailure, onSuccess: onSuccess)
        }
        
        func authorizationToken(request: URLRequest, id: String, date: Date) throws -> String {
            let sig: String = try {
                let string = try sigString(from: request)
                guard let data = string.data(using: .utf8) else {
                    throw Error.invalidSig(string)
                }
                let digest = SHA256.hash(data: data)
                let formatted = digest.map { value in
                    String(format: "%02x", value)
                }
                return formatted.joined()
            }()
            let claims = JWT.Claims(uid: userID,
                                    sid: sessionID,
                                    iat: date,
                                    exp: date.addingTimeInterval(30 * .minute),
                                    jti: id,
                                    sig: sig,
                                    scp: "FULL")
            let token = try JWT.token(claims: claims, key: privateKey)
            return "Bearer " + token
        }
        
        private func sigString(from request: URLRequest) throws -> String {
            guard
                let url = request.url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                var uri = components.string
            else {
                throw Error.invalidURL(request.url)
            }
            if let range = components.rangeOfHost {
                uri.removeSubrange(range)
            }
            if let range = components.rangeOfScheme {
                uri.removeSubrange(range)
            }
            if uri.hasPrefix("://") {
                let start = uri.startIndex
                let end = uri.index(uri.startIndex, offsetBy: 2)
                uri.removeSubrange(start...end)
            }
            
            var sig = ""
            if let method = request.httpMethod {
                sig += method
            }
            if !uri.hasPrefix("/") {
                sig += "/"
            }
            sig += uri
            if let body = request.httpBody, let content = String(data: body, encoding: .utf8), content.count > 0 {
                sig += content
            }
            return sig
        }
        
    }
    
}
