//
//  SwapViewModel.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/14.
//

import Foundation

class SwapViewModel: ObservableObject {
    
    enum Error: Swift.Error {
        case noAvailableAsset
    }
    
    enum State<Success> {
        
        case waiting
        case loading(Task<Void, Never>)
        case success(Success)
        case failed(Swift.Error)
        
        var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
        
    }
    
    @Published var swappableAssets: State<[SwappableAsset]> = .waiting
    @Published var selectedPaymentAssetIndex = 0
    @Published var selectedSettlementAssetIndex = 0
    
    private let jsonDecoder = JSONDecoder()
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        return URLSession(configuration: config)
    }()
    
    @MainActor
    func reloadSwappableAssets() async {
        guard !swappableAssets.isLoading else {
            return
        }
        let task = Task {
            do {
                let paymentAssets: [PaymentAsset] = try await {
                    let url = URL(string: "https://api.mixpay.me/v1/setting/payment_assets")!
                    let (data, _) = try await session.data(from: url)
                    let response = try jsonDecoder.decode(SwapResponse<[PaymentAsset]>.self, from: data)
                    return response.data
                }()
                let settlementAssets: [SettlementAsset] = try await {
                    let url = URL(string: "https://api.mixpay.me/v1/setting/settlement_assets")!
                    let (data, _) = try await session.data(from: url)
                    let response = try jsonDecoder.decode(SwapResponse<[SettlementAsset]>.self, from: data)
                    return response.data.filter(\.isAsset)
                }()
                let quoteAssets: [QuoteAsset] = try await {
                    let url = URL(string: "https://api.mixpay.me/v1/setting/quote_assets")!
                    let (data, _) = try await session.data(from: url)
                    let response = try jsonDecoder.decode(SwapResponse<[QuoteAsset]>.self, from: data)
                    return response.data.filter { asset in
                        asset.isAsset == 1
                    }
                }()
                let paymentAssetMap = paymentAssets.reduce(into: [:]) { partialResult, asset in
                    partialResult[asset.assetID] = asset
                }
                let settlementAssetIDs = Set(settlementAssets.map(\.assetID))
                
                let swappableAssets: [SwappableAsset] = quoteAssets.compactMap { asset in
                    guard let paymentAsset = paymentAssetMap[asset.assetID] else {
                        return nil
                    }
                    guard settlementAssetIDs.contains(asset.assetID) else {
                        return nil
                    }
                    guard let minQuoteAmount = Decimal(string: asset.minQuoteAmount) else {
                        return nil
                    }
                    guard let maxQuoteAmount = Decimal(string: asset.maxQuoteAmount) else {
                        return nil
                    }
                    let icon = AssetIcon(asset: paymentAsset.iconURL,
                                         chain: paymentAsset.chainAsset.iconURL)
                    return SwappableAsset(id: asset.assetID,
                                          symbol: paymentAsset.symbol,
                                          icon: icon,
                                          minQuoteAmount: minQuoteAmount,
                                          maxQuoteAmount: maxQuoteAmount,
                                          decimalDigit: asset.decimalDigit)
                }
                if swappableAssets.isEmpty {
                    self.swappableAssets = .failed(Error.noAvailableAsset)
                } else {
                    self.swappableAssets = .success(swappableAssets)
                }
            } catch {
                self.swappableAssets = .failed(error)
            }
        }
        swappableAssets = .loading(task)
    }
    
}
