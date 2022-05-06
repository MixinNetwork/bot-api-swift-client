//
//  AssetWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import UIKit

public final class AssetWorker: Worker {
    
    private enum Path {
        
        static let assets = "/assets"
        
        static func assets(assetId: String) -> String {
            "/assets/" + assetId
        }
        
        static func snapshots(limit: Int, offset: String? = nil, assetId: String? = nil, opponentId: String? = nil, destination: String? = nil, tag: String? = nil) -> String {
            var path = "/snapshots?limit=\(limit)"
            if let offset = offset {
                path += "&offset=\(offset)"
            }
            if let assetId = assetId {
                path += "&asset=\(assetId)"
            }
            if let opponentId = opponentId {
                path += "&opponent=\(opponentId)"
            }
            if let destination = destination {
                path += "&destination=\(destination)"
                if let tag = tag, !tag.isEmpty {
                    path += "&tag=\(tag)"
                }
            }
            return path
        }
        
    }
    
    public func assets(completion: @escaping (API.Result<[Asset]>) -> Void) {
        get(path: Path.assets, completion: completion)
    }
    
    public func assets() -> API.Result<[Asset]> {
        get(path: Path.assets)
    }
    
    public func asset(assetId: String, completion: @escaping (API.Result<Asset>) -> Void) {
        get(path: Path.assets(assetId: assetId), completion: completion)
    }
    
    public func asset(assetId: String) -> API.Result<Asset> {
        get(path: Path.assets(assetId: assetId))
    }
    
    public func snapshots(limit: Int, offset: String? = nil, assetId: String? = nil, opponentId: String? = nil, destination: String? = nil, tag: String? = nil) -> API.Result<[Snapshot]> {
        assert(limit <= 500)
        let path = Path.snapshots(limit: limit, offset: offset, assetId: assetId, opponentId: opponentId, destination: destination, tag: tag)
        return get(path: path)
    }
    
    public func snapshots(limit: Int, assetId: String, destination: String, tag: String, completion: @escaping (API.Result<[Snapshot]>) -> Void) {
        get(path: Path.snapshots(limit: limit, assetId: assetId, destination: destination, tag: tag), completion: completion)
    }
    
    public func snapshots(limit: Int, assetId: String, completion: @escaping (API.Result<[Snapshot]>) -> Void) {
        get(path: Path.snapshots(limit: limit, offset: nil, assetId: assetId, opponentId: nil), completion: completion)
    }
    
    public func fee(assetId: String, completion: @escaping (API.Result<Fee>) -> Void) {
        get(path: "/assets/\(assetId)/fee", completion: completion)
    }
    
    public func pendingDeposits(assetId: String, destination: String, tag: String, completion: @escaping (API.Result<[PendingDeposit]>) -> Void) {
        get(path: "/external/transactions?asset=\(assetId)&destination=\(destination)&tag=\(tag)", completion: completion)
    }
    
    public func search(keyword: String) -> API.Result<[Asset]>  {
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .success([])
        }
        let path = "/network/assets/search/\(encodedKeyword)"
        return get(path: path)
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
