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
    
    public let account: AccountWorker<User, MixinNetworkError>
    public let asset: AssetWorker<MixinNetworkError>
    public let collectible: CollectibleWorker<MixinNetworkError>
    public let multisig: MultisigWorker<MixinNetworkError>
    public let payment: PaymentWorker<MixinNetworkError>
    public let snapshot: SnapshotWorker<MixinNetworkError>
    public let withdrawal: WithdrawalWorker<MixinNetworkError>
    
    public init(session: Session) {
        self.account = AccountWorker<User, MixinNetworkError>(session: session)
        self.asset = AssetWorker<MixinNetworkError>(session: session)
        self.collectible = CollectibleWorker<MixinNetworkError>(session: session)
        self.multisig = MultisigWorker<MixinNetworkError>(session: session)
        self.payment = PaymentWorker<MixinNetworkError>(session: session)
        self.snapshot = SnapshotWorker<MixinNetworkError>(session: session)
        self.withdrawal = WithdrawalWorker<MixinNetworkError>(session: session)
    }
    
}
