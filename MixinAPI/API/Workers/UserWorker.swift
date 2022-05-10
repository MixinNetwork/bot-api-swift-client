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
        static func codes(codeID: String) -> String {
            return "/codes/" + codeID
        }
        static func users(id: String) -> String {
            return "/users/\(id)"
        }
        static func getFavorite(userID: String) -> String {
            return "/users/\(userID)/apps/favorite"
        }
        static func setFavorite(appID: String) -> String {
            return "/apps/\(appID)/favorite"
        }
        static func unfavorite(appID: String) -> String {
            return "/apps/\(appID)/unfavorite"
        }
        static let users = "/users/fetch"
        static let relationships = "/relationships"
        static let reports = "/reports"
        static let blockingUsers = "/blocking_users"
        static let fetchSessions = "/sessions/fetch"
    }
    
    public func codes(codeID: String, completion: @escaping (API.Result<QRCodeResponse>) -> Void) {
        get(path: Path.codes(codeID: codeID), completion: completion)
    }
    
    @discardableResult
    public func showUser(userID: String, completion: @escaping (API.Result<User>) -> Void) -> Request? {
        return get(path: Path.users(id: userID), completion: completion)
    }
    
    public func blockingUsers(completion: @escaping (API.Result<User>) -> Void) {
        get(path: Path.blockingUsers, completion: completion)
    }
    
    public func showUser(userID: String) -> API.Result<User> {
        get(path: Path.users(id: userID))
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
    
    public func addFriend(userID: String, fullName: String) -> API.Result<User> {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: fullName, action: .add)
        return post(path: Path.relationships, parameters: relationshipRequest)
    }
    
    public func addFriend(userID: String, fullName: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: fullName, action: .add)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func removeFriend(userID: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: nil, action: .remove)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func remarkFriend(userID: String, fullName: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: fullName, action: .update)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func blockUser(userID: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: nil, action: .block)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func blockUser(userID: String) -> API.Result<User> {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: nil, action: .block)
        return post(path: Path.relationships, parameters: relationshipRequest)
    }
    
    public func reportUser(userID: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: nil, action: .block)
        post(path: Path.reports, parameters: relationshipRequest, completion: completion)
    }
    
    public func reportUser(userID: String) -> API.Result<User> {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: nil, action: .block)
        return post(path: Path.reports, parameters: relationshipRequest)
    }
    
    public func unblockUser(userID: String, completion: @escaping (API.Result<User>) -> Void) {
        let relationshipRequest = RelationshipRequest(userID: userID, fullName: nil, action: .unblock)
        post(path: Path.relationships, parameters: relationshipRequest, completion: completion)
    }
    
    public func getFavoriteApps(ofUserWith id: String, completion: @escaping (API.Result<[FavoriteApp]>) -> Void) {
        get(path: Path.getFavorite(userID: id), completion: completion)
    }
    
    public func setFavoriteApp(id: String, completion: @escaping (API.Result<FavoriteApp>) -> Void) {
        post(path: Path.setFavorite(appID: id), completion: completion)
    }
    
    public func unfavoriteApp(id: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: Path.unfavorite(appID: id), completion: completion)
    }
    
    public func fetchSessions(userIds: [String]) -> API.Result<[UserSession]> {
        post(path: Path.fetchSessions, parameters: userIds)
    }
    
}
