//
//  WithdrawalWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class WithdrawalWorker: Worker {
    
    private enum Path {
        static func addresses(assetId: String) -> String {
            "/assets/\(assetId)/addresses"
        }
        
        static let addresses = "/addresses"
        static func address(addressId: String) -> String {
            "/addresses/\(addressId)"
        }
        
        static let withdrawals = "/withdrawals"
        static func delete(addressId: String) -> String {
            "/addresses/\(addressId)/delete"
        }
    }
    
    public func address(addressId: String) -> API.Result<Address> {
        return get(path: Path.address(addressId: addressId))
    }
    
    public func address(addressId: String, completion: @escaping (API.Result<Address>) -> Void) {
        get(path: Path.address(addressId: addressId), completion: completion)
    }
    
    public func addresses(assetId: String, completion: @escaping (API.Result<[Address]>) -> Void) {
        get(path: Path.addresses(assetId: assetId), completion: completion)
    }
    
    public func save(address: AddressRequest, completion: @escaping (API.Result<Address>) -> Void) {
        session.encryptPIN(address.pin, onFailure: completion) { encryptedPin in
            var address = address
            address.pin = encryptedPin
            self.post(path: Path.addresses,
                         parameters: address,
                         options: .disableRetryOnRequestSigningTimeout,
                         completion: completion)
        }
    }
    
    public func withdrawal(withdrawal: WithdrawalRequest, completion: @escaping (API.Result<Snapshot>) -> Void) {
        session.encryptPIN(withdrawal.pin, onFailure: completion) { encryptedPin in
            var withdrawal = withdrawal
            withdrawal.pin = encryptedPin
            self.post(path: Path.withdrawals,
                         parameters: withdrawal,
                         options: .disableRetryOnRequestSigningTimeout,
                         completion: completion)
        }
    }
    
    public func delete(addressId: String, pin: String, completion: @escaping (API.Result<Empty>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { encryptedPin in
            self.post(path: Path.delete(addressId: addressId),
                         parameters: ["pin_base64": encryptedPin],
                         options: .disableRetryOnRequestSigningTimeout,
                         completion: completion)
        }
    }
    
}
