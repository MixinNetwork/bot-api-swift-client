//
//  CircleWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class CircleWorker: Worker {

    private enum Path {
        
        static let circles = "/circles"
        
        static func circle(id: String) -> String {
            "/circles/\(id)"
        }
        
    }
    
    public func circles() -> API.Result<[CircleResponse]> {
        get(path: Path.circles)
    }
    
    public func circle(id: String) -> API.Result<CircleResponse> {
        get(path: Path.circle(id: id))
    }
    
    public func circle(id: String, completion: @escaping (API.Result<CircleResponse>) -> Void) {
        get(path: Path.circle(id: id), completion: completion)
    }
    
    public func circleConversations(circleID: String, offset: String?, limit: Int) -> API.Result<[CircleConversation]> {
        var path = "/circles/\(circleID)/conversations?limit=\(limit)"
        if let offset = offset {
            path += "&offset=\(offset)"
        }
        return get(path: path)
    }
    
    public func create(name: String, completion: @escaping (API.Result<CircleResponse>) -> Void) {
        post(path: Path.circles, parameters: ["name": name], completion: completion)
    }
    
    public func update(id: String, name: String, completion: @escaping (API.Result<CircleResponse>) -> Void) {
        post(path: Path.circle(id: id), parameters: ["name": name], completion: completion)
    }
    
    public func updateCircle(of id: String, requests: [CircleConversationRequest], completion: @escaping (API.Result<[CircleConversation]>) -> Void) {
        post(path: "/circles/\(id)/conversations", parameters: requests, completion: completion)
    }
    
    public func updateCircles(forConversationWith id: String, requests: [ConversationCircleRequest], completion: @escaping (API.Result<[CircleConversation]>) -> Void) {
        post(path: "/conversations/\(id)/circles", parameters: requests, completion: completion)
    }
    
    public func updateCircles(forUserWith id: String, requests: [ConversationCircleRequest], completion: @escaping (API.Result<[CircleConversation]>) -> Void) {
        post(path: "/users/\(id)/circles", parameters: requests, completion: completion)
    }
    
    public func delete(id: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: "/circles/\(id)/delete", completion: completion)
    }
    
}
