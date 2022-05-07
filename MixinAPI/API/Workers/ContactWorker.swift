//
//  ContactWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class ContactWorker: Worker {
    
    public func friends(completion: @escaping (API.Result<[User]>) -> Void) {
        get(path: "/friends", completion: completion)
    }
    
    public func upload(contacts: [PhoneContact], completion: ((API.Result<Empty>) -> Void)? = nil) {
        post(path: "/contacts", parameters: contacts) { result in
            completion?(result)
        }
    }
    
}
