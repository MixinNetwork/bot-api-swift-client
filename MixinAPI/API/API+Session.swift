//
//  API+Session.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/1.
//

import Foundation

extension API {
    
    public class Session {
        
        let host: Host
        let requestHeaders: [String: String]
        let analytic: Analytic?
        let urlSession: URLSession
        let serializationQueue = DispatchQueue(label: "one.mixin.network.api.session.serialization")
        
        public init(
            hostStorage: HostStorage,
            requestHeaders: [String: String],
            analytic: Analytic?
        ) {
            self.host = Host(storage: hostStorage)
            
            var headers = requestHeaders
            headers["Content-Type"] = "application/json"
            self.requestHeaders = headers
            
            self.analytic = analytic
            
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 10
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            let redirectionBlocker = RedirectionBlocker()
            self.urlSession = URLSession(configuration: config,
                                         delegate: redirectionBlocker,
                                         delegateQueue: nil)
        }
        
    }
    
}
