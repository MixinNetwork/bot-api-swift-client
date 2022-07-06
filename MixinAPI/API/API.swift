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
    
    public let account: AccountWorker<User, MixinError>
    public let asset: AssetWorker<MixinError>
    public let collectible: CollectibleWorker<MixinError>
    public let multisig: MultisigWorker<MixinError>
    public let payment: PaymentWorker<MixinError>
    public let snapshot: SnapshotWorker<MixinError>
    public let withdrawal: WithdrawalWorker<MixinError>
    
    public init(session: Session) {
        self.account = AccountWorker<User, MixinError>(session: session)
        self.asset = AssetWorker<MixinError>(session: session)
        self.collectible = CollectibleWorker<MixinError>(session: session)
        self.multisig = MultisigWorker<MixinError>(session: session)
        self.payment = PaymentWorker<MixinError>(session: session)
        self.snapshot = SnapshotWorker<MixinError>(session: session)
        self.withdrawal = WithdrawalWorker<MixinError>(session: session)
    }
    
}
