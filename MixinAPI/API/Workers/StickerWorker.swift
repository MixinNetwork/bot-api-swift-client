//
//  StickerWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class StickerWorker: Worker {
    
    private enum Path {
        static let albums = "/stickers/albums"
        static func albums(id: String) -> String {
            "/stickers/albums/\(id)"
        }
        static func album(id: String) -> String {
            "/albums/\(id)"
        }
        static let add = "/stickers/favorite/add"
        static let remove = "/stickers/favorite/remove"
        static func stickers(id: String) -> String {
            "/stickers/\(id)"
        }
    }
    
    public func albums() -> API.Result<[Album]> {
        get(path: Path.albums)
    }
    
    public func albums(completion: @escaping (API.Result<[Album]>) -> Void) {
        get(path: Path.albums, completion: completion)
    }
    
    public func album(albumID: String) -> API.Result<Album> {
        get(path: Path.album(id: albumID))
    }
    
    public func stickers(albumID: String, completion: @escaping (API.Result<[StickerResponse]>) -> Void) {
        get(path: Path.albums(id: albumID), completion: completion)
    }
    
    public func stickers(albumID: String) -> API.Result<[StickerResponse]> {
        get(path: Path.albums(id: albumID))
    }
    
    public func addSticker(stickerBase64: String, completion: @escaping (API.Result<StickerResponse>) -> Void) {
        post(path: Path.add, parameters: ["data_base64": stickerBase64], completion: completion)
    }
    
    public func addSticker(stickerID: String, completion: @escaping (API.Result<StickerResponse>) -> Void) {
        post(path: Path.add, parameters: ["sticker_id": stickerID], completion: completion)
    }
    
    public func sticker(stickerID: String) -> API.Result<StickerResponse> {
        get(path: Path.stickers(id: stickerID))
    }
    
    public func sticker(stickerID: String, completion: @escaping (API.Result<StickerResponse>) -> Void) {
        get(path: Path.stickers(id: stickerID), completion: completion)
    }
    
    public func removeSticker(stickerIds: [String], completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: Path.remove, parameters: stickerIds, completion: completion)
    }
    
}
