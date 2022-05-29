//
//  LoginViewModel.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/28.
//

import Foundation
import MixinAPI

class LoginViewModel: ObservableObject {
    
    typealias Result = Swift.Result<(API, Account), Swift.Error>
    
    enum Error: Swift.Error {
        case invalidUserID
        case invalidSessionID
        case invalidPINToken
        case invalidPrivateKey
    }
    
    @Published private(set) var isLoggingIn = false
    @Published private(set) var result: Result?
    @Published private(set) var errorDescription = ""
    @Published var isPresentingError = false
    
    func login(uid: String, sid: String, pinToken: String, privateKey: String) {
        assert(Thread.isMainThread)
        guard !isLoggingIn else {
            assertionFailure()
            return
        }
        self.isLoggingIn = true
        DispatchQueue.global().async {
            do {
                guard UUID(uuidString: uid) != nil else {
                    throw Error.invalidUserID
                }
                guard UUID(uuidString: sid) != nil else {
                    throw Error.invalidSessionID
                }
                guard let pinToken = Data(base64URLEncoded: pinToken) else {
                    throw Error.invalidPINToken
                }
                guard let rawKey = Data(base64URLEncoded: privateKey)?.prefix(32) else {
                    throw Error.invalidPrivateKey
                }
                let privateKey = try Ed25519PrivateKey(rawRepresentation: rawKey)
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
                        self.errorDescription = error.localizedDescription
                        self.isPresentingError = true
                    }
                    self.isLoggingIn = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.result = .failure(error)
                    self.errorDescription = error.localizedDescription
                    self.isPresentingError = true
                    self.isLoggingIn = false
                }
            }
        }
    }
    
}
