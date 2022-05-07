//
//  ProvisioningWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class ProvisioningWorker: Worker {
    
    public func code(completion: @escaping (API.Result<ProvisioningCodeResponse>) -> Void) {
        get(path: "/device/provisioning/code",
            completion: completion)
    }
    
    public func update(id: String, secret: String, completion: @escaping (API.Result<ProvisioningResponse>) -> Void) {
        post(path: "/provisionings/" + id,
             parameters: ["secret": secret],
             completion: completion)
    }
    
}
