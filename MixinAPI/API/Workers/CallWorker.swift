//
//  CallWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/4.
//

import UIKit

public class CallWorker: Worker {
    
    public func turn(queue: DispatchQueue, completion: @escaping (API.Result<[TurnServer]>) -> Void) {
        get(path: "/turn", queue: queue, completion: completion)
    }
    
}
