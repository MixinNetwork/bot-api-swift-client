//
//  SwapPaymentTrace.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/28.
//

import Foundation

@MainActor
struct SwapPaymentTrace: Identifiable {
    
    let id: String
    let caption: String
    
    private(set) var status: SwapPaymentResult.Status
    
    init(id: String, caption: String, status: SwapPaymentResult.Status) {
        self.id = id
        self.caption = caption
        self.status = status
    }
    
    mutating func startRefreshing(with request: @escaping () async -> SwapPaymentResult.Status) async {
        repeat {
            do {
                try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                status = await request()
                switch status {
                case .unpaid, .pending:
                    break
                case .success, .failed:
                    return
                }
            } catch {
                status = .failed
                return
            }
        } while true
    }
    
}
