import Foundation

public enum MultisigState: String {
    case initial
    case unlocked
    case signed
}

public enum MultisigAction: String {
    case sign
    case unlock
}

public struct MultisigResponse: Codable {
    
    public let codeID: String
    public let requestID: String
    public let action: String
    public let userID: String
    public let assetID: String
    public let amount: String
    public let senders: [String]
    public let receivers: [String]
    public let state: String
    public let transactionHash: String
    public let rawTransaction: String
    public let createdAt: String
    public let memo: String?
    
    enum CodingKeys: String, CodingKey {
        case codeID = "code_id"
        case requestID = "request_id"
        case action
        case userID = "user_id"
        case assetID = "asset_id"
        case amount
        case senders
        case receivers
        case state
        case transactionHash = "transaction_hash"
        case rawTransaction = "raw_transaction"
        case createdAt = "created_at"
        case memo
    }
    
}
