//
//  AssetWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import UIKit

fileprivate enum Path {
    
    static let assets = "/assets"
    
    static func assets(assetID: String) -> String {
        "/assets/" + assetID
    }
    
    static func snapshots(limit: Int, offset: String? = nil, assetID: String? = nil, opponentID: String? = nil, destination: String? = nil, tag: String? = nil) -> String {
        var path = "/snapshots?limit=\(limit)"
        if let offset = offset {
            path += "&offset=\(offset)"
        }
        if let assetID = assetID {
            path += "&asset=\(assetID)"
        }
        if let opponentID = opponentID {
            path += "&opponent=\(opponentID)"
        }
        if let destination = destination {
            path += "&destination=\(destination)"
            if let tag = tag, !tag.isEmpty {
                path += "&tag=\(tag)"
            }
        }
        return path
    }
    
    static func search(keyword: String) -> String {
        "/network/assets/search/\(keyword)"
    }
    
}

public final class AssetWorker<Error: ServerError & Decodable>: Worker<Error> {
    
    public func assets(queue: DispatchQueue = .main, completion: @escaping (API.Result<[Asset]>) -> Void) {
        get(path: Path.assets, queue: queue, completion: completion)
    }
    
    public func assets() -> API.Result<[Asset]> {
        get(path: Path.assets)
    }
    
    public func asset(assetID: String, completion: @escaping (API.Result<Asset>) -> Void) {
        get(path: Path.assets(assetID: assetID), completion: completion)
    }
    
    public func asset(assetID: String) -> API.Result<Asset> {
        get(path: Path.assets(assetID: assetID))
    }
    
    public func snapshots(limit: Int, offset: String? = nil, assetID: String? = nil, opponentID: String? = nil, destination: String? = nil, tag: String? = nil) -> API.Result<[Snapshot]> {
        assert(limit <= 500)
        let path = Path.snapshots(limit: limit, offset: offset, assetID: assetID, opponentID: opponentID, destination: destination, tag: tag)
        return get(path: path)
    }
    
    @discardableResult
    public func snapshots(limit: Int, offset: String? = nil, assetID: String? = nil, opponentID: String? = nil, destination: String? = nil, tag: String? = nil, queue: DispatchQueue = .main, completion: @escaping (API.Result<[Snapshot]>) -> Void) -> Request {
        assert(limit <= 500)
        let path = Path.snapshots(limit: limit, offset: offset, assetID: assetID, opponentID: opponentID, destination: destination, tag: tag)
        return get(path: path, queue: queue, completion: completion)
    }
    
    public func fee(assetID: String, completion: @escaping (API.Result<Fee>) -> Void) {
        get(path: "/assets/\(assetID)/fee", completion: completion)
    }
    
    @discardableResult
    public func pendingDeposits(assetID: String, destination: String, tag: String, completion: @escaping (API.Result<[PendingDeposit]>) -> Void) -> Request {
        get(path: "/external/transactions?asset=\(assetID)&destination=\(destination)&tag=\(tag)", completion: completion)
    }
    
    public func search(keyword: String) -> API.Result<[Asset]>  {
        if let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return get(path: Path.search(keyword: encoded))
        } else {
            return .success([])
        }
    }
    
    public func search(keyword: String, completion: @escaping (API.Result<[Asset]>) -> Void) -> Request {
        if let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return get(path: Path.search(keyword: encoded), completion: completion)
        } else {
            let request = Request()
            DispatchQueue.main.async {
                if request.isCancelled {
                    completion(.failure(TransportError.cancelled))
                } else {
                    completion(.success([]))
                }
            }
            return request
        }
    }
    
    public func topAssets<Asset>(completion: @escaping (API.Result<[Asset]>) -> Void) {
        get(path: "/network/assets/top?kind=NORMAL", completion: completion)
    }
    
    public func fiats(completion: @escaping (API.Result<[FiatMoney]>) -> Void) {
        get(path: "/fiats", completion: completion)
    }
    
    public func ticker(asset: String, offset: String, completion: @escaping (API.Result<Ticker>) -> Void) {
        get(path: "/ticker?asset=\(asset)&offset=\(offset)", completion: completion)
    }
    
}
