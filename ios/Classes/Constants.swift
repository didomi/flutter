//
//  Constants.swift
//  didomi_sdk
//
//  Created by Philémon Merlet on 10/05/2021.
//

struct Constants {
    // Channels names
    static let methodsChannelName = "didomi_sdk"
    static let eventsChannelName = "didomi_sdk/events"
    
    static let bundleId = "org.cocoapods.didomi-sdk"
    
    // User Agent
    static let userAgentVersion: String = Bundle(identifier: bundleId)?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let userAgentName = "Didomi Flutter SDK"
    
    
}
