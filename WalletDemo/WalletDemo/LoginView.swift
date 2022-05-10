//
//  LoginView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/4.
//

import SwiftUI
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

struct LoginView: View {
    
    private enum LoginError: Error {
        case invalidPINToken
        case invalidPrivateKey
    }
    
    @State private var uid = "(None)"
    @State private var sid = "(None)"
    @State private var pinToken = "(None)"
    @State private var key = "(None)"
    
    private var session: Result<API.AuthenticatedSession, Error> {
        do {
            guard let pinToken = Data(base64URLEncoded: pinToken) else {
                throw LoginError.invalidPINToken
            }
            guard let rawKey = Data(base64URLEncoded: key)?.prefix(32) else {
                throw LoginError.invalidPrivateKey
            }
            let privateKey = try Ed25519PrivateKey(rawRepresentation: rawKey)
            let client = Client(userAgent: "WalletDemo 0.1.0")
            let iterator = PINIterator()
            let consoleOutput = ConsoleOutput()
            let session = API.AuthenticatedSession(userId: uid,
                                                   sessionId: sid,
                                                   pinToken: pinToken,
                                                   privateKey: privateKey,
                                                   client: client,
                                                   hostStorage: WalletHost(),
                                                   pinIterator: iterator,
                                                   analytic: consoleOutput)
            return .success(session)
        } catch {
            return .failure(error)
        }
    }
    
    var body: some View {
        Form {
            Section {
                Text(uid)
                Button("Paste") {
                    if let string = UIPasteboard.general.string {
                        uid = string
                    }
                }
            } header: {
                Text("User ID")
            }
            
            Section {
                Text(sid)
                Button("Paste") {
                    if let string = UIPasteboard.general.string {
                        sid = string
                    }
                }
            } header: {
                Text("Session ID")
            }
            
            Section {
                Text(key)
                Button("Paste") {
                    if let string = UIPasteboard.general.string {
                        key = string
                    }
                }
            } header: {
                Text("PIN Token")
            }
            
            Section {
                Text(pinToken)
                Button("Paste") {
                    if let string = UIPasteboard.general.string {
                        pinToken = string
                    }
                }
            } header: {
                Text("Private Key")
            }
            
            Section {
                switch session {
                case .success(let session):
                    NavigationLink("API Test") {
                        APITestView(session: session)
                    }
                case .failure(let error):
                    Text("Invalid Session")
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                }
            }
        }
        .navigationTitle("Session")
        .listStyle(GroupedListStyle())
    }
    
}
