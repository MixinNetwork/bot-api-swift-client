//
//  SessionRequest.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/6.
//

import Foundation

public struct SessionRequest {
    
    let platform: String
    let platformVersion: String
    let packageName: String
    let appVersion: String
    let notificationToken: String?
    let voipToken: String?
    let deviceCheckToken: String?
    
    init(client: Client, notificationToken: String?, voipToken: String?, deviceCheckToken: String?) {
        self.platform = client.platform
        self.platformVersion = client.platformVersion
        self.packageName = client.bundleIdentifier
        self.appVersion = client.bundleVersion
        self.notificationToken = notificationToken
        self.voipToken = voipToken
        self.deviceCheckToken = deviceCheckToken
    }
    
}

extension SessionRequest: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case platform
        case platformVersion = "platform_version"
        case packageName = "package_name"
        case appVersion = "app_version"
        case notificationToken = "notification_token"
        case voipToken = "voip_token"
        case deviceCheckToken = "device_check_token"
    }
    
}
