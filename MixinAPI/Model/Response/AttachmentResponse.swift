//
//  AttachmentResponse.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public struct AttachmentResponse {
    
    public let attachmentId: String
    public let uploadUrl: String?
    public let viewUrl: String?
    public let createdAt: String?
    
}

extension AttachmentResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case attachmentId = "attachment_id"
        case uploadUrl = "upload_url"
        case viewUrl = "view_url"
        case createdAt = "created_at"
    }
    
}
