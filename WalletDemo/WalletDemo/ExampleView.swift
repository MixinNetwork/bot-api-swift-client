//
//  ExampleView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/10.
//

import Foundation
import SwiftUI
import MixinAPI

struct ExampleView: View {
    
    @State private var isPresentingPINAlert = false
    
    @StateObject private var example: Example
    
    var body: some View {
        VStack {
            Text(example.output)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Spacer()
            Button {
                isPresentingPINAlert = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.accentColor)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
                    if example.isRunning {
                        ProgressView()
                    } else {
                        Text("Run")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
            }
            .padding(.horizontal)
            .disabled(example.isRunning)
        }
        .navigationTitle("Example")
        .textFieldAlert(isPresented: $isPresentingPINAlert, title: "Input PIN", text: nil, placeholder: "PIN", keyboardType: .numberPad) { pin in
            if let pin = pin {
                example.run(pin: pin)
            }
        }
    }
    
    init(session: API.AuthenticatedSession) {
        _example = StateObject(wrappedValue: Example(session: session))
    }
    
}
