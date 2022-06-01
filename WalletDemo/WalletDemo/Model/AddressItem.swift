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
    
    init(address: Address) {
        self.address = address
        if let date = DateFormatter.iso8601.date(from: address.updatedAt) {
            self.date = DateFormatter.mediumDate.string(from: date)
        } else {
            self.date = address.updatedAt
        }
    }
    
}

extension AddressItem: Identifiable {
    
    var id: String {
        address.id
    }
    
}
