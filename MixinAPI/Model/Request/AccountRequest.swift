//
//  AccountRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/5.
//

import Foundation

public class AccountRequest {
    
    public let code: String?
    public let registrationID: Int?
    public let platform: String
    public let platformVersion: String
    public let packageName: String
    public let appVersion: String
    public let purpose: String
    public var pin: String?
    public let sessionSecret: String?
    
    private init(client: Client, code: String?, registrationID: Int?, purpose: String, pin: String?, sessionSecret: String?) {
        self.code = code
        self.registrationID = registrationID
        self.platform = client.platform
        self.platformVersion = client.platformVersion
        self.packageName = client.bundleIdentifier
        self.appVersion = client.bundleVersion
        self.purpose = purpose
        self.pin = pin
        self.sessionSecret = sessionSecret
    }
    
    static func session(code: String, registrationID: Int, sessionSecret: String, client: Client) -> AccountRequest {
        AccountRequest(client: client,
                       code: code,
                       registrationID: registrationID,
                       purpose: VerificationPurpose.session.rawValue,
                       pin: nil,
                       sessionSecret: sessionSecret)
    }
    
    static func phone(code: String, pin: String, client: Client) -> AccountRequest {
        AccountRequest(client: client,
                       code: code,
                       registrationID: nil,
                       purpose: VerificationPurpose.phone.rawValue,
                       pin: pin,
                       sessionSecret: nil)
    }
    
}

extension AccountRequest: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case code
        case registrationID = "registration_id"
        case platform
        case platformVersion = "platform_version"
        case packageName = "package_name"
        case appVersion = "app_version"
        case purpose
        case pin = "pin_base64"
        case sessionSecret = "session_secret"
    }
    
}
