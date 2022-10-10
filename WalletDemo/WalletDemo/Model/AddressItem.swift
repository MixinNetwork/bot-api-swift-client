//
//  AddressItem.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/2.
//

import Foundation
import MixinAPI

struct AddressItem {
    
    let address: Address
    let date: String
    let fee: Decimal
    let feeSymbol: String
    let dust: Decimal
    let reserve: Decimal
    
    init(address: Address, feeSymbol: String) {
        self.address = address
        if let date = DateFormatter.iso8601.date(from: address.updatedAt) {
            self.date = DateFormatter.mediumDate.string(from: date)
        } else {
            self.date = address.updatedAt
        }
        self.fee = Decimal(string: address.fee) ?? 0
        self.feeSymbol = feeSymbol
        self.dust = Decimal(string: address.dust) ?? 0
        self.reserve = Decimal(string: address.reserve) ?? 0
    }
    
}

extension AddressItem: Identifiable {
    
    var id: String {
        address.id
    }
    
}
