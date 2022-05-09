//
//  SignalKeyWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/9.
//

import Foundation

public final class SignalKeyWorker: Worker {
    
    private enum Path {
        static let signal = "/signal/keys"
        static let signalKeyCount = "/signal/keys/count"
    }
    
    public func pushSignalKeys(key: SignalKeyRequest) -> API.Result<Empty> {
        post(path: "/signal/keys", parameters: key)
    }
    
    public func getSignalKeyCount() -> API.Result<SignalKeyCount> {
        get(path: "/signal/keys/count")
    }
    
}
