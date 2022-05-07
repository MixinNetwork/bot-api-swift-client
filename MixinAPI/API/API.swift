//
//  API.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/4/28.
//

import Foundation

public final class API {
    
    public static let unauthorizedNotification = Notification.Name(rawValue: "one.mixin.network.api.Unauthorized")
    public static let clockSkewDetectedNotification = Notification.Name(rawValue: "one.mixin.network.api.ClockSkewDetected")
    
    public enum Error: Swift.Error {
        case local(LocalError)
        case remote(RemoteError)
    }
    
    public typealias Result<Response: Decodable> = Swift.Result<Response, Error>
    
    public let accountWorker: AccountWorker
    public let asset: AssetWorker
    public let authorize: AuthorizeWorker
    public let call: CallWorker
    public let circle: CircleWorker
    public let collectible: CollectibleWorker
    public let conversation: ConversationWorker
    public let emergency: EmergencyWorker
    public let external: ExternalWorker
    public let message: MessageWorker
    public let contact: ContactWorker
    public let multisig: MultisigWorker
    public let payment: PaymentWorker
    public let provisioning: ProvisioningWorker
    public let snapshot: SnapshotWorker
    public let sticker: StickerWorker
    public let user: UserWorker
    public let withdrawal: WithdrawalWorker
    
    public init(session: Session) {
        self.accountWorker = AccountWorker(session: session)
        self.asset = AssetWorker(session: session)
        self.authorize = AuthorizeWorker(session: session)
        self.call = CallWorker(session: session)
        self.circle = CircleWorker(session: session)
        self.collectible = CollectibleWorker(session: session)
        self.conversation = ConversationWorker(session: session)
        self.emergency = EmergencyWorker(session: session)
        self.external = ExternalWorker(session: session)
        self.message = MessageWorker(session: session)
        self.contact = ContactWorker(session: session)
        self.multisig = MultisigWorker(session: session)
        self.payment = PaymentWorker(session: session)
        self.provisioning = ProvisioningWorker(session: session)
        self.snapshot = SnapshotWorker(session: session)
        self.sticker = StickerWorker(session: session)
        self.user = UserWorker(session: session)
        self.withdrawal = WithdrawalWorker(session: session)
    }
    
}
