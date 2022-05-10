//
//  Example.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/10.
//

import Foundation
import MixinAPI

class Example: ObservableObject {
    
    @Published private(set) var isRunning = false
    @Published private(set) var output = ""
    
    private let api: API
    private let btcAssetID = "c6d0c728-2624-429b-8e0d-d9d19b6592fa"
    
    private var pin = ""
    
    init(session: API.AuthenticatedSession) {
        self.api = API(session: session)
    }
    
    func run(pin: String) {
        self.pin = pin
        getBTCTicker()
    }
    
    private func getBTCTicker() {
        isRunning = true
        let offset = "2020-10-03T15:08:43.583258Z"
        output += "Get BTC's value on 2020-10-03..."
        api.asset.ticker(asset: btcAssetID, offset: offset) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let ticker):
                self.output += "\(ticker.usdPrice)\n"
            case .failure(let error):
                self.output += "\nError: \(error)\n"
            }
            self.getFiats()
        }
    }
    
    private func getFiats() {
        output += "Get fiats..."
        api.asset.fiats { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let fiats):
                self.output += "\(fiats.count) Items\n"
            case .failure(let error):
                self.output += "\nError: \(error)\n"
            }
            self.getBTCFee()
        }
    }
    
    private func getBTCFee() {
        output += "Get BTC's fee..."
        api.asset.fee(assetID: btcAssetID) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let fee):
                self.output += "\(fee.amount)\n"
            case .failure(let error):
                self.output += "\nError: \(error)\n"
            }
            self.transferCNB()
        }
    }
    
    private func transferCNB() {
        output += "Transfer 1 CNB to someone..."
        let cnb = "965e5c6e-434c-3fa9-b780-c50f43cd955c"
        let opponent = "9b13a3c9-aec0-4375-b86f-f9edfb27e92b"
        let traceID = UUID().uuidString.lowercased()
        api.payment.transfer(assetID: cnb, opponentID: opponent, amount: "1", memo: "Hello", pin: pin, traceID: traceID) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let snapshot):
                self.output += "✅\n"
                self.output += "\(snapshot)\n"
            case .failure(let error):
                self.output += "\nError: \(error)\n"
            }
            self.output += "Ended\n"
            self.isRunning = false
        }
    }
    
}
