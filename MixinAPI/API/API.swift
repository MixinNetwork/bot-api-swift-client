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
    
    public let accountWorker: AccountWorker
    public let authorize: AuthorizeWorker
    public let call: CallWorker
    
    public init(session: Session) {
        self.accountWorker = AccountWorker(session: session)
        self.authorize = AuthorizeWorker(session: session)
        self.call = CallWorker(session: session)
    }
    
}
