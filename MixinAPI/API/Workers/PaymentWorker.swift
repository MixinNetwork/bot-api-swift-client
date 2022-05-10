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
    
    public func payments(assetID: String, opponentID: String, amount: String, traceID: String) -> API.Result<PaymentResponse> {
        let parameters: [String: Any] = [
            "asset_id": assetID,
            "opponent_id": opponentID,
            "amount": amount,
            "trace_id": traceID
        ]
        return post(path: Path.payments, parameters: parameters)
    }
    
    public func payments(assetID: String, addressID: String, amount: String, traceID: String) -> API.Result<PaymentResponse> {
        let parameters: [String: Any] = [
            "asset_id": assetID,
            "address_id": addressID,
            "amount": amount,
            "trace_id": traceID
        ]
        return post(path: Path.payments, parameters: parameters)
    }
    
    public func transactions(transactionRequest: RawTransactionRequest, pin: String, completion: @escaping (API.Result<Snapshot>) -> Void) {
        var transactionRequest = transactionRequest
        session.encryptPIN(pin, onFailure: completion) { encryptedPIN in
            transactionRequest.pin = encryptedPIN
            self.post(path: Path.transactions, parameters: transactionRequest, options: .disableRetryOnRequestSigningTimeout, completion: completion)
        }
    }
    
    public func transfer(assetID: String, opponentID: String, amount: String, memo: String, pin: String, traceID: String, completion: @escaping (API.Result<Snapshot>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { encryptedPIN in
            let param = ["asset_id": assetID, "opponent_id": opponentID, "amount": amount, "memo": memo, "pin_base64": encryptedPIN, "trace_id": traceID]
            self.post(path: Path.transfers, parameters: param, options: .disableRetryOnRequestSigningTimeout, completion: completion)
        }
    }
    
}
