//
//  App.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/3.
//

import Foundation

public struct App: Decodable {
    
    public let appID: String
    public let appNumber: String
    public let redirectURI: String
    public let name: String
    public let iconURL: String
    public let capabilities: [String]?
    public let resourcePatterns: [String]?
    public let homeURI: String
    public let creatorID: String
    public let updatedAt: String?
    public let category: String
    
}
