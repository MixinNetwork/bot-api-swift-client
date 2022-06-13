//
//  AESCryptor.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/30.
//

import Foundation
import CommonCrypto

enum AESCryptor {
    
    public enum Padding {
        case none
        case pkcs7
    }
    
    enum Error: Swift.Error {
        case badInput
        case createCryptor(CCStatus)
        case update(CCStatus)
        case finalize(CCStatus)
    }
    
    static func encrypt(_ plainData: Data, with key: Data, iv: Data, padding: Padding) throws -> Data {
        let options: CCOptions
        switch padding {
        case .none:
            if plainData.count % kCCBlockSizeAES128 != 0 {
                throw Error.badInput
            } else {
                options = 0
            }
        case .pkcs7:
            options = CCOptions(kCCOptionPKCS7Padding)
        }
        return try crypt(input: plainData,
                         operation: CCOperation(kCCEncrypt),
                         key: key,
                         iv: iv,
                         options: options)
    }
    
    static func decrypt(_ cipher: Data, with key: Data, iv: Data) throws -> Data {
        try crypt(input: cipher, operation: CCOperation(kCCDecrypt), key: key, iv: iv, options: 0)
    }
    
    private static func crypt(input: Data, operation: CCOperation, key: Data, iv: Data, options: CCOptions) throws -> Data {
        var cryptor: CCCryptorRef! = nil
        var status = key.withUnsafeBytes { keyBuffer in
            iv.withUnsafeBytes { ivBuffer in
                CCCryptorCreate(operation,
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBuffer.baseAddress,
                                keyBuffer.count,
                                ivBuffer.baseAddress,
                                &cryptor)
            }
        }
        guard status == kCCSuccess else {
            throw Error.createCryptor(status)
        }
        
        let outputCount = CCCryptorGetOutputLength(cryptor, input.count, true)
        let output = malloc(outputCount)!
        var dataOutMoved: size_t = 0
        status = input.withUnsafeBytes { inputBuffer in
            CCCryptorUpdate(cryptor,
                            inputBuffer.baseAddress,
                            inputBuffer.count,
                            output,
                            outputCount,
                            &dataOutMoved)
        }
        guard status == kCCSuccess else {
            CCCryptorRelease(cryptor)
            free(output)
            throw Error.update(status)
        }
        
        status = CCCryptorFinal(cryptor,
                                output.advanced(by: dataOutMoved),
                                outputCount - dataOutMoved,
                                &dataOutMoved)
        guard status == kCCSuccess else {
            CCCryptorRelease(cryptor)
            free(output)
            throw Error.finalize(status)
        }
        
        CCCryptorRelease(cryptor)
        return Data(bytesNoCopy: output, count: outputCount, deallocator: .free)
    }
    
}
