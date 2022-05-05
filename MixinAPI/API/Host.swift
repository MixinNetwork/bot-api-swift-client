//
//  Host.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/29.
//

import Foundation

public protocol HostStorage {
    func index() -> Int
    func save(index: Int)
}

public class Host {
    
    private let storage: HostStorage
    private let lock = NSLock()
    private let all = [
        ("mixin-blaze.zeromesh.net", "mixin-api.zeromesh.net"),
        ("blaze.mixin.one", "api.mixin.one")
    ]
    
    private var index: Int
    
    init(storage: HostStorage) {
        self.storage = storage
        self.index = storage.index()
    }
    
    func webSocket() -> (index: Int, value: String) {
        lock.lock()
        let index = self.index
        lock.unlock()
        return (index, all[index].0)
    }
    
    func http() -> (index: Int, value: String) {
        lock.lock()
        let index = self.index
        lock.unlock()
        return (index, all[index].1)
    }
    
    func toggle(from current: Int) {
        lock.lock()
        defer {
            lock.unlock()
        }
        guard current == index else {
            return
        }
        let advanced = current + 1
        if advanced >= all.count {
            index = 0
        } else {
            index = advanced
        }
        storage.save(index: index)
    }
    
}
