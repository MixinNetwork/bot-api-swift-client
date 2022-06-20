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
    
    @Published var selectedPaymentAssetIndex = 0
    @Published var selectedSettlementAssetIndex = 0
    
    @Published private(set) var swappableAssets: State<[SwappableAsset]> = .waiting
    @Published private(set) var isCreatingPayment = false
    @Published private(set) var paymentError: Swift.Error?
    @Published var traceID: String?
    
    private let clientID: String
    private let walletViewModel: WalletViewModel
    private let jsonDecoder = JSONDecoder()
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        return URLSession(configuration: config)
    }()
    
    init(clientID: String, walletViewModel: WalletViewModel) {
        self.clientID = clientID
        self.walletViewModel = walletViewModel
    }
    
    @MainActor
    func reloadSwappableAssets() async {
        guard !swappableAssets.isLoading else {
            return
        }
        let task = Task {
            do {
                let paymentAssetIDs: Set<String> = try await {
                    let url = URL(string: "https://api.mixpay.me/v1/setting/payment_assets")!
                    let (data, _) = try await session.data(from: url)
                    let response = try jsonDecoder.decode(SwapResponse<[PaymentAsset]>.self, from: data)
                    let ids = response.data.map(\.assetID)
                    return Set(ids)
                }()
                let settlementAssetIDs: Set<String> = try await {
                    let url = URL(string: "https://api.mixpay.me/v1/setting/settlement_assets")!
                    let (data, _) = try await session.data(from: url)
                    let response = try jsonDecoder.decode(SwapResponse<[SettlementAsset]>.self, from: data)
                    let ids = response.data.filter(\.isAsset).map(\.assetID)
                    return Set(ids)
                }()
                let quoteAssets: [QuoteAsset] = try await {
                    let url = URL(string: "https://api.mixpay.me/v1/setting/quote_assets")!
                    let (data, _) = try await session.data(from: url)
                    let response = try jsonDecoder.decode(SwapResponse<[QuoteAsset]>.self, from: data)
                    return response.data.filter { asset in
                        asset.isAsset == 1
                    }
                }()
                
                var swappableAssets: [SwappableAsset] = []
                for asset in quoteAssets {
                    guard paymentAssetIDs.contains(asset.assetID) else {
                        continue
                    }
                    guard settlementAssetIDs.contains(asset.assetID) else {
                        continue
                    }
                    let itemExists: Bool
                    if walletViewModel.allAssetItems[asset.id] != nil {
                        itemExists = true
                    } else {
                        itemExists = await withCheckedContinuation { continuation in
                            walletViewModel.reloadAsset(with: asset.id) { item in
                                continuation.resume(returning: item != nil)
                            }
                        }
                    }
                    guard itemExists else {
                        continue
                    }
                    guard let minQuoteAmount = Decimal(string: asset.minQuoteAmount) else {
                        continue
                    }
                    guard let maxQuoteAmount = Decimal(string: asset.maxQuoteAmount) else {
                        continue
                    }
                    let asset = SwappableAsset(id: asset.assetID,
                                               minQuoteAmount: minQuoteAmount,
                                               minQuoteAmountString: asset.minQuoteAmount,
                                               maxQuoteAmount: maxQuoteAmount,
                                               maxQuoteAmountString: asset.maxQuoteAmount,
                                               decimalDigit: asset.decimalDigit)
                    swappableAssets.append(asset)
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
    
    @MainActor
    func createPayment(quoteAssetID: String, quoteAmount: String, settlementAssetID: String) async {
        paymentError = nil
        isCreatingPayment = true
        let traceID = UUID().uuidString.lowercased()
        let request: URLRequest = {
            var components = URLComponents(string: "https://api.mixpay.me/v1/payments")!
            components.queryItems = [
                URLQueryItem(name: "payeeId", value: clientID),
                URLQueryItem(name: "traceId", value: traceID),
                URLQueryItem(name: "paymentAssetId", value: quoteAssetID),
                URLQueryItem(name: "quoteAssetId", value: quoteAssetID),
                URLQueryItem(name: "quoteAmount", value: quoteAmount),
                URLQueryItem(name: "settlementAssetId", value: settlementAssetID),
            ]
            var request = URLRequest(url: components.url!)
            request.httpMethod = "POST"
            return request
        }()
        do {
            let (data, _) = try await session.data(for: request)
            let response = try jsonDecoder.decode(SwapResponse<SwapPayment>.self, from: data)
            walletViewModel.swap(payment: response.data) {
                self.traceID = response.data.traceID
            }
        } catch {
            paymentError = error
        }
        isCreatingPayment = false
    }
    
    @MainActor
    func paymentStatus(traceID: String) async -> SwapPaymentResult.Status {
        let url = URL(string: "https://api.mixpay.me/v1/payments_result?traceId=\(traceID)")!
        do {
            let (data, _) = try await session.data(from: url)
            let response = try jsonDecoder.decode(SwapResponse<SwapPaymentResult>.self, from: data)
            return response.data.status
        } catch {
            return .failed
        }
    }
    
}
