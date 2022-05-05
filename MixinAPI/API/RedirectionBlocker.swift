//
//  RedirectionBlocker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/3.
//

import Foundation

class RedirectionBlocker: NSObject, URLSessionDelegate {
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        completionHandler(nil)
    }
    
}
