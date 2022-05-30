//
//  API.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/28.
//

import Foundation

public final class API {
    
    public static let unauthorizedNotification = Notification.Name(rawValue: "one.mixin.api.Unauthorized")
    public static let clockSkewDetectedNotification = Notification.Name(rawValue: "one.mixin.api.ClockSkewDetected")
    
    public typealias Result<Response: Decodable> = Swift.Result<Response, Error>
    
    public let account: AccountWorker
    public let asset: AssetWorker
    public let collectible: CollectibleWorker
    public let multisig: MultisigWorker
    public let payment: PaymentWorker
    public let snapshot: SnapshotWorker
    public let withdrawal: WithdrawalWorker
    
    public init(session: Session) {
        self.account = AccountWorker(session: session)
        self.asset = AssetWorker(session: session)
        self.collectible = CollectibleWorker(session: session)
        self.multisig = MultisigWorker(session: session)
        self.payment = PaymentWorker(session: session)
        self.snapshot = SnapshotWorker(session: session)
        self.withdrawal = WithdrawalWorker(session: session)
    }
    
}
