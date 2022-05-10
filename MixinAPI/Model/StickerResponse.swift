//
//  StickerResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct StickerResponse {
    
    public let stickerID: String
    public let name: String
    public let assetURL: String
    public let assetType: String
    public let assetWidth: Int
    public let assetHeight: Int
    public let createdAt: String
    public let albumID: String?
    
}

extension StickerResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case stickerID = "sticker_id"
        case name
        case assetURL = "asset_url"
        case assetType = "asset_type"
        case assetWidth = "asset_width"
        case assetHeight = "asset_height"
        case createdAt = "created_at"
        case albumID = "album_id"
    }
    
}
