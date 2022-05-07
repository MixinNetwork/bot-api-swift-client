//
//  PhoneContact.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class PhoneContact: NSObject {
    
    @objc public let fullName: String
    public let phoneNumber: String
    
    public init(fullName: String, phoneNumber: String) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
    }
    
}

extension PhoneContact: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case phoneNumber = "phone"
    }
    
}
