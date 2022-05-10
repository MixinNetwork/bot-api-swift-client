//
//  AttachmentResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct AttachmentResponse {
    
    public let attachmentID: String
    public let uploadURL: String?
    public let viewURL: String?
    public let createdAt: String?
    
}

extension AttachmentResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case attachmentID = "attachment_id"
        case uploadURL = "upload_url"
        case viewURL = "view_url"
        case createdAt = "created_at"
    }
    
}
