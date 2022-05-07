//
//  UserWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class UserWorker: Worker {
    
    private enum Path {
        static func search(keyword: String) -> String {
            return "/search/" + keyword
        }
        static func codes(codeId: String) -> String {
            return "/codes/" + codeId
        }
        static func users(id: String) -> String {
            return "/users/\(id)"
        }
        static func getFavorite(userId: String) -> String {
            return "/users/\(userId)/apps/favorite"
        }
        static func setFavorite(appId: String) -> String {
            return "/apps/\(appId)/favorite"
        }
        static func unfavorite(appId: String) -> String {
            return "/apps/\(appId)/unfavorite"
        }
        static let users = "/users/fetch"
        static let relationships = "/relationships"
        static let reports = "/reports"
        static let blockingUsers = "/blocking_users"
        static let fetchSessions = "/sessions/fetch"
    }
    
    public func codes(codeId: String, completion: @escaping (API.Result<QRCodeResponse>) -> Void) {
        get(path: Path.codes(codeId: codeId), completion: completion)
    }
    
    @discardableResult
    public func showUser(userId: String, completion: @escaping (API.Result<User>) -> Void) -> Request? {
        return get(path: Path.users(id: userId), completion: completion)
    }
    
    public func blockingUsers(completion: @escaping (API.Result<User>) -> Void) {
        get(path: Path.blockingUsers, completion: completion)
    }
    
    public func showUser(userId: String) -> API.Result<User> {
        get(path: Path.users(id: userId))
    }
    
    public func showUsers(userIds: [String]) -> API.Result<[User]> {
        post(path: Path.users, parameters: userIds)
    }
    
    @discardableResult
    public func showUsers(userIds: [String], completion: @escaping (API.Result<[User]>) -> Void) -> Request? {
        post(path: Path.users, parameters: userIds, completion: completion)
    }
    
    @discardableResult
    public func search(keyword: String, completion: @escaping (API.Result<User>) -> Void) -> Request? {
        return get(path: Path.search(keyword: keyword), completion: completion)
    }
    
    public func search(keyword: String) -> API.Result<User> {
        return get(path: Path.search(keyword: keyword))
    }
    
    public func addFriend(userId: String, fullName: String) -> API.Result<User> {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: fullName, action: .ADD)
        return post(path: Path.relationships, parameters: relationshipRequest)
    }
    
    public func addFriend(userId: String, fullName: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: fullName, action: .ADD)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func removeFriend(userId: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: nil, action: .REMOVE)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func remarkFriend(userId: String, full_name: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: full_name, action: .UPDATE)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func blockUser(userId: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: nil, action: .BLOCK)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func blockUser(userId: String) -> API.Result<User> {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: nil, action: .BLOCK)
        return post(path: Path.relationships, parameters: relationshipRequest)
    }
    
    public func reportUser(userId: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: nil, action: .BLOCK)
        post(path: Path.reports, parameters: relationshipRequest, completion: completion)
    }
    
    public func reportUser(userId: String) -> API.Result<User> {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: nil, action: .BLOCK)
        return post(path: Path.reports, parameters: relationshipRequest)
    }
    
    public func unblockUser(userId: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(user_id: userId, full_name: nil, action: .UNBLOCK)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func getFavoriteApps(ofUserWith id: String, completion: @escaping (API.Result<[FavoriteApp]>) -> Void) {
        get(path: Path.getFavorite(userId: id), completion: completion)
    }
    
    public func setFavoriteApp(id: String, completion: @escaping (API.Result<FavoriteApp>) -> Void) {
        post(path: Path.setFavorite(appId: id), completion: completion)
    }
    
    public func unfavoriteApp(id: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: Path.unfavorite(appId: id), completion: completion)
    }
    
    public func fetchSessions(userIds: [String]) -> API.Result<[UserSession]> {
        post(path: Path.fetchSessions, parameters: userIds)
    }
    
}
