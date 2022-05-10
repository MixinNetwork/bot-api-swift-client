//
//  APITestView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/4/28.
//

import SwiftUI
import MixinAPI

struct APITestView: View {
    
    @StateObject private var test: APITest
    
    @State private var isPresentingPINAlert = false
    @State private var isPresentingResult = false
    @State private var isManualTestRunning = false
    @State private var lastResult = ""
    
    var body: some View {
        List {
            Section {
                Button {
                    isPresentingPINAlert = true
                } label: {
                    HStack {
                        Text("Start Test")
                        Spacer()
                        if test.isRunning {
                            ProgressView()
                        }
                    }
                }
                .disabled(test.isRunning)
                .disabled(isManualTestRunning)
            }
            
            ForEach(test.caseGroups) { group in
                Section {
                    ForEach(group.cases) { testCase in
                        Button {
                            self.isManualTestRunning = true
                            testCase.runWithCompletion { result in
                                lastResult = result
                                isPresentingResult = true
                                self.isManualTestRunning = false
                            }
                        } label: {
                            HStack {
                                Text(testCase.name)
                                Spacer()
                                switch testCase.state {
                                case .waiting:
                                    Spacer()
                                case .running:
                                    ProgressView()
                                case .failed:
                                    Text("❌")
                                case .succeed:
                                    Text("✅")
                                }
                            }
                        }
                        .disabled(test.isRunning)
                        .disabled(isManualTestRunning)
                    }
                } header: {
                    Text(group.caption)
                }
            }
        }
        .navigationTitle("API Test")
        .listStyle(GroupedListStyle())
        .textFieldAlert(isPresented: $isPresentingPINAlert, title: "Input your PIN", text: nil, placeholder: "PIN", keyboardType: .numberPad) { pin in
            if let pin = pin {
                test.start(pin: pin)
            }
        }
        .alert(isPresented: $isPresentingResult) {
            let copyButton = Alert.Button.default(Text("Copy")) {
                UIPasteboard.general.string = lastResult
            }
            return Alert(title: Text("Response"),
                         message: Text(lastResult),
                         primaryButton: .cancel(),
                         secondaryButton: copyButton)
        }
    }
    
    init(session: API.AuthenticatedSession) {
        let test = APITest(session: session)
        _test = StateObject(wrappedValue: test)
    }
    
}
