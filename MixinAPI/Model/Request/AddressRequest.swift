//
//  AddressRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct AddressRequest: Codable {
    
    public let assetId: String
    public let destination: String
    public let tag: String
    public let label: String
    public var pin: String
    
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case destination
        case label
        case tag
        case pin = "pin_base64"
    }
    
    public init(assetId: String, destination: String, tag: String, label: String, pin: String) {
        self.assetId = assetId
        self.destination = destination
        self.tag = tag
        self.label = label
        self.pin = pin
    }
    
}
