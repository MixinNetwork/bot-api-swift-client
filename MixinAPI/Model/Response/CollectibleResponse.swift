import Foundation

public enum CollectibleState: String {
    case initial
    case unlocked
    case signed
}

public enum CollectibleAction: String {
    case unlock
    case sign
}

public struct CollectibleResponse: Codable {
    
    public let type: String
    public let codeID: String
    public let requestID: String
    public let userID: String
    public let tokenID: String
    public let amount: String
    public let sendersThreshold: Int64
    public let senders: [String]
    public let receiversThreshold: Int64
    public let receivers: [String]
    public let signers: [String]
    public let action: String
    public let state: String
    public let transactionHash: String
    public let rawTransaction: String
    public let createdAt: String
    public let memo: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case codeID = "code_id"
        case requestID = "request_id"
        case userID = "user_id"
        case tokenID = "token_id"
        case amount
        case sendersThreshold = "senders_threshold"
        case senders
        case receiversThreshold = "receivers_threshold"
        case receivers
        case signers
        case action
        case state
        case transactionHash = "transaction_hash"
        case rawTransaction = "raw_transaction"
        case createdAt = "created_at"
        case memo
    }
    
}
