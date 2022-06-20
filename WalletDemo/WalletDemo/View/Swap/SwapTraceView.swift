//
//  SwapTraceView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/20.
//

import SwiftUI

struct SwapTraceView: View {
    
    let traceID: String
    let onCancel: () -> Void
    
    @State private var task: Task<Void, Never>?
    @State private var status: SwapPaymentResult.Status = .unpaid
    
    @EnvironmentObject private var walletViewModel: WalletViewModel
    @EnvironmentObject private var swapViewModel: SwapViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            Group {
                switch status {
                case .unpaid:
                    VStack(spacing: 08) {
                        ProgressView()
                        Text("Tracing swap result")
                            .padding(.bottom, 8)
                        Button {
                            onCancel()
                        } label: {
                            Text("Cancel")
                                .padding(4)
                        }
                        .tint(.accentColor)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)
                        .buttonBorderShape(.roundedRectangle(radius: 16))
                    }
                case .success:
                    Image(systemName: "checkmark.circle")
                        .imageScale(.large)
                        .foregroundColor(.green)
                        .padding()
                case .failed:
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .background {
                Color(.systemBackground)
                    .cornerRadius(16)
                    .padding(-20)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            task = Task {
                repeat {
                    do {
                        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                        status = await swapViewModel.paymentStatus(traceID: traceID)
                    } catch {
                        return
                    }
                } while !Task.isCancelled
            }
        }
        .onDisappear {
            task?.cancel()
        }
        .onChange(of: status) { status in
            switch status {
            case .success:
                walletViewModel.reloadAssets(completion: nil)
                fallthrough
            case .failed:
                task?.cancel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    swapViewModel.traceID = nil
                }
            case .unpaid:
                break
            }
        }
    }
    
}
