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
        
        static func join(codeID: String) -> String {
            return "/conversations/\(codeID)/join"
        }
        
        static func mute(conversationID: String) -> String {
            return "/conversations/\(conversationID)/mute"
        }
        
        static func reset(conversationID: String) -> String {
            return "/conversations/\(conversationID)/rotate"
        }
        
    }
    
    public func createConversation(conversation: ConversationRequest, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        post(path: Path.conversations, parameters: conversation, completion: completion)
    }
    
    public func createConversation(conversation: ConversationRequest) -> API.Result<ConversationResponse> {
        post(path: Path.conversations, parameters: conversation)
    }
    
    public func getConversation(conversationID: String) -> API.Result<ConversationResponse> {
        get(path: Path.conversations(id: conversationID))
    }
    
    public func exitConversation(conversationID: String, completion: @escaping (API.Result<Empty>) -> Void) {
        post(path: Path.exit(id: conversationID), completion: completion)
    }
    
    public func joinConversation(codeID: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        post(path: Path.join(codeID: codeID), completion: completion)
    }
    
    public func addParticipant(conversationID: String, participantUserIds: [String], completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let parameters = participantUserIds.map({ ["user_id": $0, "role": ""] })
        post(path: Path.participants(id: conversationID, action: .add), parameters: parameters, completion: completion)
    }
    
    public func removeParticipant(conversationID: String, userID: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let parameters = [["user_id": userID, "role": ""]]
        post(path: Path.participants(id: conversationID, action: .remove), parameters: parameters, completion: completion)
    }
    
    public func adminParticipant(conversationID: String, userID: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let parameters = [["user_id": userID, "role": Participant.Role.admin.rawValue]]
        post(path: Path.participants(id: conversationID, action: .role), parameters: parameters, completion: completion)
    }
    
    public func dismissAdminParticipant(conversationID: String, userID: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let parameters = [["user_id": userID, "role": ""]]
        post(path: Path.participants(id: conversationID, action: .role), parameters: parameters, completion: completion)
    }
    
    public func updateGroupName(conversationID: String, name: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let conversationRequest = ConversationRequest(conversationID: conversationID, name: name, category: nil, participants: nil, duration: nil, announcement: nil)
        post(path: Path.conversations(id: conversationID), parameters: conversationRequest, completion: completion)
    }
    
    public func updateGroupAnnouncement(conversationID: String, announcement: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        let conversationRequest = ConversationRequest(conversationID: conversationID, name: nil, category: nil, participants: nil, duration: nil, announcement: announcement)
        post(path: Path.conversations(id: conversationID), parameters: conversationRequest, completion: completion)
    }
    
    public func mute(conversationID: String, conversationRequest: ConversationRequest, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        post(path: Path.mute(conversationID: conversationID), parameters: conversationRequest, completion: completion)
    }
    
    public func updateCodeID(conversationID: String, completion: @escaping (API.Result<ConversationResponse>) -> Void) {
        post(path: Path.reset(conversationID: conversationID), completion: completion)
    }
    
}
