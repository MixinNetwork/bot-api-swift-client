//
//  Authentication.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/17.
//

import Foundation

final class Authentication {
    
    struct Field {
        let title: String
        let description: String
    }
    
    enum Operation {
        case verify(confirmation: [Field])
        case initialize
    }
    
    enum State {
        case waiting
        case loading
        case success
        case failure(Error)
    }
    
    let title: String
    let operation: Operation
    let onPINInput: (String, @escaping (State) -> Void) -> Void
    
    init(title: String, operation: Authentication.Operation, onPINInput: @escaping (String, @escaping (State) -> Void) -> Void) {
        self.title = title
        self.operation = operation
        self.onPINInput = onPINInput
    }
    
}
