//
//  ConversationWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class ConversationWorker: Worker {
    
    private enum Path {
        static let conversations = "/conversations"
        static func conversations(id: String) -> String {
            return "/conversations/\(id)"
        }
        
        static func participants(id: String, action: Participant.Action) -> String {
            return "/conversations/\(id)/participants/\(action.rawValue)"
        }
        
        static func exit(id: String) -> String {
            return "/conversations/\(id)/exit"
        }
        
        static func join(codeId: String) -> String {
            return "/conversations/\(codeId)/join"
        }
        
        static func mute(conversationId: String) -> String {
            return "/conversations/\(conversationId)/mute"
        }
        
        static func reset(conversationId: String) -> String {
            return "/conversations/\(conversationId)/rotate"
        }
        
    }
    
    public func createConversation(conversation: ConversationRequest, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        post(path: Path.conversations, parameters: conversation, completion: completion)
    }
    
    public func createConversation(conversation: ConversationRequest) -> API.Result<ConversationResponse> {
        post(path: Path.conversations, parameters: conversation)
    }
    
    public func getConversation(conversationId: String) -> API.Result<ConversationResponse> {
        get(path: Path.conversations(id: conversationId))
    }
    
    public func exitConversation(conversationId: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: Path.exit(id: conversationId), completion: completion)
    }
    
    public func joinConversation(codeId: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        post(path: Path.join(codeId: codeId), completion: completion)
    }
    
    public func addParticipant(conversationId: String, participantUserIds: [String], completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let parameters = participantUserIds.map({ ["user_id": $0, "role": ""] })
        post(path: Path.participants(id: conversationId, action: .add), parameters: parameters, completion: completion)
    }
    
    public func removeParticipant(conversationId: String, userId: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let parameters = [["user_id": userId, "role": ""]]
        post(path: Path.participants(id: conversationId, action: .remove), parameters: parameters, completion: completion)
    }
    
    public func adminParticipant(conversationId: String, userId: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let parameters = [["user_id": userId, "role": Participant.Role.admin.rawValue]]
        post(path: Path.participants(id: conversationId, action: .role), parameters: parameters, completion: completion)
    }
    
    public func dismissAdminParticipant(conversationId: String, userId: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let parameters = [["user_id": userId, "role": ""]]
        post(path: Path.participants(id: conversationId, action: .role), parameters: parameters, completion: completion)
    }
    
    public func updateGroupName(conversationId: String, name: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let conversationRequest = ConversationRequest(conversationId: conversationId, name: name, category: nil, participants: nil, duration: nil, announcement: nil)
        post(path: Path.conversations(id: conversationId), parameters: conversationRequest, completion: completion)
    }
    
    public func updateGroupAnnouncement(conversationId: String, announcement: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let conversationRequest = ConversationRequest(conversationId: conversationId, name: nil, category: nil, participants: nil, duration: nil, announcement: announcement)
        post(path: Path.conversations(id: conversationId), parameters: conversationRequest, completion: completion)
    }
    
    public func mute(conversationId: String, conversationRequest: ConversationRequest, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        post(path: Path.mute(conversationId: conversationId), parameters: conversationRequest, completion: completion)
    }
    
    public func updateCodeId(conversationId: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        post(path: Path.reset(conversationId: conversationId), completion: completion)
    }
    
}
