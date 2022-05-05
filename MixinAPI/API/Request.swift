//
//  Request.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/1.
//

import Foundation

public class Request {
    
    public var isCancelled: Bool {
        lock.lock()
        let isCancelled = cancelled
        lock.unlock()
        return isCancelled
    }
    
    private let lock = NSLock()
    
    private var cancelled = false
    private var task: URLSessionTask?
    
    public func cancel() {
        lock.lock()
        cancelled = true
        task?.cancel()
        lock.unlock()
    }
    
    // Returns true on success, false on cancelled
    func setTask(_ task: URLSessionTask) -> Bool {
        let success: Bool
        lock.lock()
        if isCancelled {
            success = false
        } else {
            self.task = task
            success = true
        }
        lock.unlock()
        return success
    }
    
}
