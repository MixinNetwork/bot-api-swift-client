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
    
    @ObservedObject var viewModel: LoginViewModel
    
    @State private var uid = "(None)"
    @State private var sid = "(None)"
    @State private var pinToken = "(None)"
    @State private var key = "(None)"
    
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
                Text(pinToken)
                Button("Paste") {
                    if let string = UIPasteboard.general.string {
                        pinToken = string
                    }
                }
            } header: {
                Text("PIN Token")
            }
            
            Section {
                Text(key)
                Button("Paste") {
                    if let string = UIPasteboard.general.string {
                        key = string
                    }
                }
            } header: {
                Text("Private Key")
            }
            
            Section {
                Button {
                    viewModel.login(uid: uid, sid: sid, pinToken: pinToken, privateKey: key)
                } label: {
                    HStack {
                        Text("Login")
                        if viewModel.isLoggingIn {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
            }
        }
        .navigationTitle("Login")
        .listStyle(GroupedListStyle())
        .disabled(viewModel.isLoggingIn)
        .alert(isPresented: $viewModel.isPresentingError) {
            Alert(title: Text("Failed"),
                  message: Text(viewModel.errorDescription),
                  dismissButton: .cancel())
        }
    }
    
}
