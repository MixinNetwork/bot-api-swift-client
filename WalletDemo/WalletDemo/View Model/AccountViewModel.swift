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
    
    @Published private(set) var result: Result<(API, User), Error>?
    
    private let clientID = ""
    private let sessionID = ""
    private let pinToken = ""
    private let privateKey = ""
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(clockSkewDetected(_:)), name: API.clockSkewDetectedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionUnauthorized(_:)), name: API.unauthorizedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reloadAccount() {
        self.result = nil
        guard UUID(uuidString: clientID) != nil else {
            fatalError("Invalid Client ID")
        }
        guard UUID(uuidString: sessionID) != nil else {
            fatalError("Invalid Session ID")
        }
        guard let pinToken = Data(base64URLEncoded: pinToken) else {
            fatalError("Invalid PIN Token")
        }
        guard let privateKey = Data(base64URLEncoded: privateKey)?.prefix(32) else {
            fatalError("Invalid Private Key")
        }
        let client = Client(userAgent: "WalletDemo 0.1.0")
        let iterator = CurrentTimePINIterator()
        let consoleOutput = ConsoleOutput()
        let session = try! API.AuthenticatedSession(userID: clientID,
                                                    sessionID: sessionID,
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
    
    @objc private func clockSkewDetected(_ notification: Notification) {
        result = .failure(TransportError.clockSkewDetected)
    }
    
    @objc private func sessionUnauthorized(_ notification: Notification) {
        result = .failure(RemoteError.unauthorized)
    }
    
}
