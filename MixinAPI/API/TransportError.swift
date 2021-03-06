//
//  TransportError.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/28.
//

import Foundation

public enum TransportError: Error {
    
    case cancelled
    case invalidPath(String)
    case taskFailed(Error)
    case invalidStatusCode(Int)
    case invalidResponse(URLResponse?)
    case noData(HTTPURLResponse)
    case clockSkewDetected
    case buildURLRequest(Error)
    case requestSigningTimeout
    case invalidJSON(Error)
    case pinEncryption(Error)
    case unauthorizedSession
    case syncRequestFailed
    case mismatchedRequestID
    
}
