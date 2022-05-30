//
//  AccountViewModel.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/28.
//

import Foundation
import MixinAPI

extension Data {
    
    init?(base64URLEncoded string: String) {
        var str = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if string.count % 4 != 0 {
            str.append(String(repeating: "=", count: 4 - string.count % 4))
        }
        self.init(base64Encoded: str)
    }
    
}

class AccountViewModel: ObservableObject {
    
    @Published private(set) var result: Result<(API, Account), Error>?
    
    private let uid = ""
    private let sid = ""
    private let pinToken = ""
    private let privateKey = ""
    
    func loadAccount() {
        self.result = nil
        guard UUID(uuidString: uid) != nil else {
            fatalError("Invalid User ID")
        }
        guard UUID(uuidString: sid) != nil else {
            fatalError("Invalid Session ID")
        }
        guard let pinToken = Data(base64URLEncoded: pinToken) else {
            fatalError("Invalid PIN Token")
        }
        guard let rawKey = Data(base64URLEncoded: privateKey)?.prefix(32) else {
            fatalError("Invalid Private Key")
        }
        let privateKey = try! Ed25519PrivateKey(rawRepresentation: rawKey)
        let client = Client(userAgent: "WalletDemo 0.1.0")
        let iterator = CurrentTimePINIterator()
        let consoleOutput = ConsoleOutput()
        let session = API.AuthenticatedSession(userID: uid,
                                               sessionID: sid,
                                               pinToken: pinToken,
                                               privateKey: privateKey,
                                               client: client,
                                               hostStorage: WalletHost(),
                                               pinIterator: iterator,
                                               analytic: consoleOutput)
        let api = API(session: session)
        api.account.me { result in
            switch result {
            case let .success(account):
                self.result = .success((api, account))
            case let .failure(error):
                self.result = .failure(error)
            }
        }
    }
    
}
