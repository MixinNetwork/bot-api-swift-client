//
//  MessageWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class MessageWorker: Worker {
    
    public func acknowledgements(ackMessages: [AckMessage]) -> API.Result<Empty> {
        post(path: "/acknowledgements", parameters: ackMessages)
    }
    
    public func messageStatus(offset: Int64) -> API.Result<[BlazeMessageData]> {
        get(path: "/messages/status/\(offset)")
    }
    
    public func requestAttachment() -> API.Result<AttachmentResponse> {
        post(path: "/attachments")
    }
    
    public func requestAttachment(queue: DispatchQueue, completion: @escaping (API.Result<AttachmentResponse>) -> Void) -> Request {
        post(path: "/attachments", queue: queue, completion: completion)
    }
    
    public func getAttachment(id: String) -> API.Result<AttachmentResponse> {
        get(path: "/attachments/\(id)")
    }
    
}
