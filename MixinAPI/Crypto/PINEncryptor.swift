//
//  PINEncryptor.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/6.
//

import Foundation
import CommonCrypto

final class PINEncryptor {
    
    enum Error: Swift.Error {
        case invalidPIN
        case missingPINToken
        case ivGeneration
        case encryption(Swift.Error)
    }
    
    private let queue = DispatchQueue(label: "one.mixin.api.PINEncryptor")
    private let key: Data
    private let iterator: PINIterator
    private let analytic: Analytic?
    
    init(key: Data, iterator: PINIterator, analytic: Analytic?) {
        self.key = key
        self.iterator = iterator
        self.analytic = analytic
    }
    
    func encrypt<Response>(pin: String, onFailure: @escaping (API.Result<Response>) -> Void, onSuccess: @escaping (String) -> Void) {
        queue.async {
            switch self.encrypt(pin: pin) {
            case .success(let encrypted):
                onSuccess(encrypted)
            case .failure(let error):
                DispatchQueue.main.async {
                    onFailure(.failure(TransportError.pinEncryption(error)))
                }
            }
        }
    }
    
    private func encrypt(pin: String) -> Result<String, Error> {
        guard let pinData = pin.data(using: .utf8) else {
            return .failure(.invalidPIN)
        }
        guard let iv = Data(withNumberOfSecuredRandomBytes: AESCryptor.blockSize) else {
            return .failure(.ivGeneration)
        }
        
        let time = UInt64(Date().timeIntervalSince1970)
        let timeData = withUnsafeBytes(of: time.littleEndian, { Data($0) })
        let iterator = self.iterator.value()
        let iteratorData = withUnsafeBytes(of: iterator.littleEndian, { Data($0) })
        analytic?.log(level: .info, category: "PINEncryptor", message: "Encrypt with it: \(iterator)", userInfo: nil)
        
        let plain = pinData + timeData + iteratorData
        do {
            let encrypted = try AESCryptor.encrypt(plain, with: key, iv: iv, padding: .pkcs7)
            let base64Encoded = (iv + encrypted).base64URLEncodedString()
            return .success(base64Encoded)
        } catch {
            return .failure(.encryption(error))
        }
    }
    
}
