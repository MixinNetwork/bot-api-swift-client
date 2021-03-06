//
//  WithdrawalWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

fileprivate enum Path {
    
    static let addresses = "/addresses"
    static let withdrawals = "/withdrawals"
    
    static func addresses(assetID: String) -> String {
        "/assets/\(assetID)/addresses"
    }
    
    static func address(addressID: String) -> String {
        "/addresses/\(addressID)"
    }
    
}

public final class WithdrawalWorker<Error: ServerError & Decodable>: Worker<Error> {
    
    public func address(addressID: String) -> API.Result<Address> {
        return get(path: Path.address(addressID: addressID))
    }
    
    public func address(addressID: String, completion: @escaping (API.Result<Address>) -> Void) {
        get(path: Path.address(addressID: addressID), completion: completion)
    }
    
    public func addresses(assetID: String, completion: @escaping (API.Result<[Address]>) -> Void) {
        get(path: Path.addresses(assetID: assetID), completion: completion)
    }
    
    public func save(address: AddressRequest, completion: @escaping (API.Result<Address>) -> Void) {
        session.encryptPIN(address.pin, onFailure: completion) { encryptedPIN in
            var address = address
            address.pin = encryptedPIN
            self.post(path: Path.addresses,
                      parameters: address,
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func withdrawal(withdrawal: WithdrawalRequest, completion: @escaping (API.Result<Snapshot>) -> Void) {
        session.encryptPIN(withdrawal.pin, onFailure: completion) { encryptedPIN in
            var withdrawal = withdrawal
            withdrawal.pin = encryptedPIN
            self.post(path: Path.withdrawals,
                      parameters: withdrawal,
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func delete(addressID: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { encryptedPIN in
            self.post(path: "/addresses/\(addressID)/delete",
                      parameters: ["pin_base64": encryptedPIN],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
}
