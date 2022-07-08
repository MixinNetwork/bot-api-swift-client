//
//  PendingDepositItem.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/7/8.
//

import Foundation
import MixinAPI

struct PendingDepositItem {
    
    let deposit: PendingDeposit
    let progress: Double
    let date: String
    
    init(pendingDeposit: PendingDeposit) {
        self.deposit = pendingDeposit
        self.progress = Double(pendingDeposit.confirmations) / Double(pendingDeposit.threshold)
        if let date = DateFormatter.iso8601.date(from: deposit.createdAt) {
            self.date = DateFormatter.general.string(from: date)
        } else {
            self.date = deposit.createdAt
        }
    }
    
}

extension PendingDepositItem: Identifiable {
    
    var id: String {
        deposit.transactionHash
    }
    
}
