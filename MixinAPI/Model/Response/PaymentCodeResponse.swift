import Foundation

public struct PaymentCodeResponse: Codable {
    
    public let codeID: String
    public let assetID: String
    public let amount: String
    public let receivers: [String]
    public let status: String
    public let threshold: Int
    public let memo: String
    public let traceID: String
    public let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case codeID = "code_id"
        case assetID = "asset_id"
        case amount
        case receivers
        case status
        case threshold
        case memo
        case traceID = "trace_id"
        case createdAt = "created_at"
    }
    
}
