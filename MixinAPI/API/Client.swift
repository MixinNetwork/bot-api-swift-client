//
//  Client.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/6.
//

import Foundation

public struct Client {
    
    let deviceID: String?
    let platform: String
    let platformVersion: String
    let bundleIdentifier: String
    let bundleVersion: String
    let acceptLanguage: String
    let userAgent: String
    
    public init(
        deviceID: String? = nil,
        platform: String? = nil,
        platformVersion: String? = nil,
        bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "null",
        bundleVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "null",
        acceptLanguage: String = Locale.current.languageCode ?? "en",
        userAgent: String
    ) {
        self.deviceID = deviceID
        
        if let platform = platform {
            self.platform = platform
        } else {
#if os(iOS)
            self.platform = "iOS"
#elseif os(macOS)
            self.platform = "macOS"
#elseif os(watchOS)
            self.platform = "watchOS"
#elseif os(tvOS)
            self.platform = "tvOS"
#else
            self.platform = "Apple"
#endif
        }
        
        if let version = platformVersion {
            self.platformVersion = version
        } else {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            self.platformVersion = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        }
        
        self.bundleIdentifier = bundleIdentifier
        self.bundleVersion = bundleVersion
        self.acceptLanguage = acceptLanguage
        self.userAgent = userAgent
    }
    
}
