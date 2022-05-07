//
//  PaymentWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class PaymentWorker: Worker {
    
    private enum Path {
        static let transactions = "/transactions"
        static let transfers = "/transfers"
        static let payments = "/payments"
    }
    
    public func payments(assetId: String, opponentId: String, amount: String, traceId: String) -> API.Result<PaymentResponse> {
        let parameters: [String: Any] = [
            "asset_id": assetId,
            "opponent_id": opponentId,
            "amount": amount,
            "trace_id": traceId
        ]
        return post(path: Path.payments, parameters: parameters)
    }
    
    public func payments(assetId: String, addressId: String, amount: String, traceId: String) -> API.Result<PaymentResponse> {
        let parameters: [String: Any] = [
            "asset_id": assetId,
            "address_id": addressId,
            "amount": amount,
            "trace_id": traceId
        ]
        return post(path: Path.payments, parameters: parameters)
    }
    
    public func transactions(transactionRequest: RawTransactionRequest, pin: String, completion: @escaping (API.Result<Snapshot>) -> Void) {
        var transactionRequest = transactionRequest
        session.encryptPIN(pin, onFailure: completion) { encryptedPin in
            transactionRequest.pin = encryptedPin
            self.post(path: Path.transactions, parameters: transactionRequest, options: .disableRetryOnRequestSigningTimeout, completion: completion)
        }
    }
    
    public func transfer(assetId: String, opponentId: String, amount: String, memo: String, pin: String, traceId: String, completion: @escaping (API.Result<Snapshot>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { encryptedPin in
            let param = ["asset_id": assetId, "opponent_id": opponentId, "amount": amount, "memo": memo, "pin_base64": encryptedPin, "trace_id": traceId]
            self.post(path: Path.transfers, parameters: param, options: .disableRetryOnRequestSigningTimeout, completion: completion)
        }
    }
    
}
