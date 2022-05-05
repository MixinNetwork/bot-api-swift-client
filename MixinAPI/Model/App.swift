//
//  App.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/3.
//

import Foundation

public struct App {
    
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

extension App: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case appID = "app_id"
        case appNumber = "app_number"
        case redirectURI = "redirect_uri"
        case name
        case iconURL = "icon_url"
        case capabilities
        case resourcePatterns = "resource_patterns"
        case homeURI = "home_uri"
        case creatorID = "creator_id"
        case updatedAt = "updated_at"
        case category
    }
    
}
