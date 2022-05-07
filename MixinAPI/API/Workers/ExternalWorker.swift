//
//  ExternalWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class ExternalWorker: Worker {
    
    public func schemes(completion: @escaping (API.Result<[String]>) -> Void) {
        get(path: "/external/schemes", completion: completion)
    }
    
}
