//
//  DidomiEventStreamHandler.swift
//  didomi_sdk
//
//  Created by Philémon Merlet on 07/05/2021.
//

import Flutter
import Didomi

/// Handler for SDK events
class DidomiEventStreamHandler : NSObject, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    let eventListener = EventListener()
    
    override init() {
        super.init()
        
        eventListener.onReady = { [unowned self] event in
            self.sendEvent(eventType: "onReady")
        }
        eventListener.onError = { [unowned self] event in
            self.sendEvent(eventType: "onError", arguments: ["message": event.descriptionText])
        }
        eventListener.onShowNotice = { [unowned self] event in
            self.sendEvent(eventType: "onShowNotice")
        }
        eventListener.onHideNotice = { [unowned self] event in
            self.sendEvent(eventType: "onHideNotice")
        }
        eventListener.onNoticeClickAgree = { [unowned self] event in
            self.sendEvent(eventType: "onNoticeClickAgree")
        }
        eventListener.onNoticeClickDisagree = { [unowned self] event in
            self.sendEvent(eventType: "onNoticeClickDisagree")
        }
        eventListener.onNoticeClickViewVendors = { [unowned self] event in
            self.sendEvent(eventType: "onNoticeClickViewVendors")
        }
        eventListener.onNoticeClickMoreInfo = { [unowned self] event in
            self.sendEvent(eventType: "onNoticeClickMoreInfo")
        }
        eventListener.onNoticeClickPrivacyPolicy = { [unowned self] event in
            self.sendEvent(eventType: "onNoticeClickPrivacyPolicy")
        }
        eventListener.onPreferencesClickAgreeToAll = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickAgreeToAll")
        }
        eventListener.onPreferencesClickDisagreeToAll = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickDisagreeToAll")
        }
        eventListener.onPreferencesClickPurposeAgree = { [unowned self] event, purposeId in
            self.sendEvent(eventType: "onPreferencesClickPurposeAgree", arguments: ["purposeId": purposeId])
        }
        eventListener.onPreferencesClickPurposeDisagree = { [unowned self] event, purposeId in
            self.sendEvent(eventType: "onPreferencesClickPurposeDisagree", arguments: ["purposeId": purposeId])
        }
        eventListener.onPreferencesClickCategoryAgree = { [unowned self] event, categoryId in
            self.sendEvent(eventType: "onPreferencesClickCategoryAgree", arguments: ["categoryId": categoryId])
        }
        eventListener.onPreferencesClickCategoryDisagree = { [unowned self] event, categoryId in
            self.sendEvent(eventType: "onPreferencesClickCategoryDisagree", arguments: ["categoryId": categoryId])
        }
        eventListener.onPreferencesClickViewVendors = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickViewVendors")
        }
        eventListener.onPreferencesClickSaveChoices = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickSaveChoices")
        }
        eventListener.onPreferencesClickVendorAgree = { [unowned self] event, vendorId in
            self.sendEvent(eventType: "onPreferencesClickVendorAgree", arguments: ["vendorId": vendorId])
        }
        eventListener.onPreferencesClickVendorDisagree = { [unowned self] event, vendorId in
            self.sendEvent(eventType: "onPreferencesClickVendorDisagree", arguments: ["vendorId": vendorId])
        }
        eventListener.onPreferencesClickVendorSaveChoices = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickVendorSaveChoices")
        }
        eventListener.onPreferencesClickViewPurposes = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickViewPurposes")
        }
        eventListener.onConsentChanged = { [unowned self] event in
            self.sendEvent(eventType: "onConsentChanged")
        }
        eventListener.onPreferencesClickAgreeToAllPurposes = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickAgreeToAllPurposes")
        }
        eventListener.onPreferencesClickDisagreeToAllPurposes = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickDisagreeToAllPurposes")
        }
        eventListener.onPreferencesClickResetAllPurposes = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickResetAllPurposes")
        }
        eventListener.onPreferencesClickAgreeToAllVendors = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickAgreeToAllVendors")
        }
        eventListener.onPreferencesClickDisagreeToAllVendors = { [unowned self] event in
            self.sendEvent(eventType: "onPreferencesClickDisagreeToAllVendors")
        }
        eventListener.onSyncDone = { [unowned self] event, organizationUserId in
            self.sendEvent(eventType: "onSyncDone", arguments: ["organizationUserId": organizationUserId])
        }
    }
        
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
        
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    func onReadyCallback() {
        self.sendEvent(eventType: "onReadyCallback")
    }
    
    func onErrorCallback() {
        self.sendEvent(eventType: "onErrorCallback")
    }
    
    func sendEvent(eventType: String, arguments: Dictionary<String, String?>? = nil) {
        let eventDictionary: NSMutableDictionary = NSMutableDictionary()
        eventDictionary.setValue(eventType, forKey: "type")
        if let arguments = arguments {
            for (name, value) in arguments {
                if let value = value {
                    eventDictionary.setValue(value, forKey: name)
                }
            }
        }
        if let jsonEvent = try? JSONSerialization.data(withJSONObject: eventDictionary) {
            let jsonString = String(data: jsonEvent, encoding: String.Encoding.utf8)
            eventSink?(jsonString)
        }
    }
}
