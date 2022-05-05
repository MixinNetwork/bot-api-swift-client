//
//  API.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/28.
//

import Foundation

public final class API {
    
    public static let unauthorizedNotification = Notification.Name(rawValue: "one.mixin.network.api.Unauthorized")
    public static let clockSkewDetectedNotification = Notification.Name(rawValue: "one.mixin.network.api.ClockSkewDetected")
    
    public enum Error: Swift.Error {
        case local(LocalError)
        case remote(RemoteError)
    }
    
    public typealias Result<Response: Decodable> = Swift.Result<Response, Error>
    
    public let authorize: AuthorizeWorker
    public let call: CallWorker
    
    let session: Session
    
    public init(session: Session) {
        self.authorize = AuthorizeWorker(session: session)
        self.call = CallWorker(session: session)
        self.session = session
    }
    
}
