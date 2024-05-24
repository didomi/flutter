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
    // We keep references to all the Sync Ready events being registered so we can call their respective syncAcknowledged callback from the Flutter side through a method channel.
    private var syncReadyEventReferences: [Int: SyncReadyEvent] = [:]
    // Index used to keep track of the Sync Ready events being registered.
    private var syncReadyEventIndex: Int = 0
    let eventListener = EventListener()
    
    override init() {
        super.init()

        // SDK lifecycle events
        eventListener.onReady = { [weak self] event in
            self?.sendEvent(eventType: "onReady")
        }
        eventListener.onError = { [weak self] event in
            self?.sendEvent(eventType: "onError", arguments: ["message": event.descriptionText])
        }

        // Notice events
        eventListener.onShowNotice = { [weak self] event in
            self?.sendEvent(eventType: "onShowNotice")
        }
        eventListener.onHideNotice = { [weak self] event in
            self?.sendEvent(eventType: "onHideNotice")
        }
        eventListener.onShowPreferences = { [weak self] event in
            self?.sendEvent(eventType: "onShowPreferences")
        }
        eventListener.onHidePreferences = { [weak self] event in
            self?.sendEvent(eventType: "onHidePreferences")
        }
        eventListener.onNoticeClickAgree = { [weak self] event in
            self?.sendEvent(eventType: "onNoticeClickAgree")
        }
        eventListener.onNoticeClickDisagree = { [weak self] event in
            self?.sendEvent(eventType: "onNoticeClickDisagree")
        }
        eventListener.onNoticeClickViewVendors = { [weak self] event in
            self?.sendEvent(eventType: "onNoticeClickViewVendors")
        }
        eventListener.onNoticeClickViewSPIPurposes = { [weak self] event in
            self?.sendEvent(eventType: "onNoticeClickViewSPIPurposes")
        }
        eventListener.onNoticeClickMoreInfo = { [weak self] event in
            self?.sendEvent(eventType: "onNoticeClickMoreInfo")
        }
        eventListener.onNoticeClickPrivacyPolicy = { [weak self] event in
            self?.sendEvent(eventType: "onNoticeClickPrivacyPolicy")
        }

        // Preferences screen events
        eventListener.onPreferencesClickAgreeToAll = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickAgreeToAll")
        }
        eventListener.onPreferencesClickDisagreeToAll = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickDisagreeToAll")
        }
        eventListener.onPreferencesClickPurposeAgree = { [weak self] event, purposeId in
            self?.sendEvent(eventType: "onPreferencesClickPurposeAgree", arguments: ["purposeId": purposeId])
        }
        eventListener.onPreferencesClickPurposeDisagree = { [weak self] event, purposeId in
            self?.sendEvent(eventType: "onPreferencesClickPurposeDisagree", arguments: ["purposeId": purposeId])
        }
        eventListener.onPreferencesClickCategoryAgree = { [weak self] event, categoryId in
            self?.sendEvent(eventType: "onPreferencesClickCategoryAgree", arguments: ["categoryId": categoryId])
        }
        eventListener.onPreferencesClickCategoryDisagree = { [weak self] event, categoryId in
            self?.sendEvent(eventType: "onPreferencesClickCategoryDisagree", arguments: ["categoryId": categoryId])
        }
        eventListener.onPreferencesClickViewVendors = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickViewVendors")
        }
        eventListener.onPreferencesClickViewSPIPurposes = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickViewSPIPurposes")
        }
        eventListener.onPreferencesClickSaveChoices = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickSaveChoices")
        }
        eventListener.onPreferencesClickAgreeToAllPurposes = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickAgreeToAllPurposes")
        }
        eventListener.onPreferencesClickDisagreeToAllPurposes = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickDisagreeToAllPurposes")
        }
        eventListener.onPreferencesClickResetAllPurposes = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickResetAllPurposes")
        }

        // Vendors screen events
        eventListener.onPreferencesClickVendorAgree = { [weak self] event, vendorId in
            self?.sendEvent(eventType: "onPreferencesClickVendorAgree", arguments: ["vendorId": vendorId])
        }
        eventListener.onPreferencesClickVendorDisagree = { [weak self] event, vendorId in
            self?.sendEvent(eventType: "onPreferencesClickVendorDisagree", arguments: ["vendorId": vendorId])
        }
        eventListener.onPreferencesClickVendorSaveChoices = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickVendorSaveChoices")
        }
        eventListener.onPreferencesClickViewPurposes = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickViewPurposes")
        }
        eventListener.onPreferencesClickAgreeToAllVendors = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickAgreeToAllVendors")
        }
        eventListener.onPreferencesClickDisagreeToAllVendors = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickDisagreeToAllVendors")
        }

        // SPI screen events
        eventListener.onPreferencesClickSPIPurposeAgree = { [weak self] event, purposeId in
            self?.sendEvent(eventType: "onPreferencesClickSPIPurposeAgree", arguments: ["purposeId": purposeId])
        }
        eventListener.onPreferencesClickSPIPurposeDisagree = { [weak self] event, purposeId in
            self?.sendEvent(eventType: "onPreferencesClickSPIPurposeDisagree", arguments: ["purposeId": purposeId])
        }
        eventListener.onPreferencesClickSPICategoryAgree = { [weak self] event, categoryId in
            self?.sendEvent(eventType: "onPreferencesClickSPICategoryAgree", arguments: ["categoryId": categoryId])
        }
        eventListener.onPreferencesClickSPICategoryDisagree = { [weak self] event, categoryId in
            self?.sendEvent(eventType: "onPreferencesClickSPICategoryDisagree", arguments: ["categoryId": categoryId])
        }
        eventListener.onPreferencesClickSPIPurposeSaveChoices = { [weak self] event in
            self?.sendEvent(eventType: "onPreferencesClickSPIPurposeSaveChoices")
        }

        // Consent events
        eventListener.onConsentChanged = { [weak self] event in
            self?.sendEvent(eventType: "onConsentChanged")
        }
        eventListener.onSyncReady = { [weak self] event in
            guard let strongSelf = self else {
                return
            }
            strongSelf.syncReadyEventIndex += 1
            strongSelf.syncReadyEventReferences[strongSelf.syncReadyEventIndex] = event
            strongSelf.sendEvent(eventType: "onSyncReady", arguments: ["statusApplied": event.statusApplied, "syncReadyEventIndex": strongSelf.syncReadyEventIndex])
        }
        eventListener.onSyncDone = { [weak self] event, organizationUserId in
            self?.sendEvent(eventType: "onSyncDone", arguments: ["organizationUserId": organizationUserId])
        }
        eventListener.onSyncError = { [weak self] event, error in
            self?.sendEvent(eventType: "onSyncError", arguments: ["error": error])
        }

        // Language change events
        eventListener.onLanguageUpdated = { [weak self] event, languageCode in
            self?.sendEvent(eventType: "onLanguageUpdated", arguments: ["languageCode": languageCode])
        }
        eventListener.onLanguageUpdateFailed = { [weak self] event, reason in
            self?.sendEvent(eventType: "onLanguageUpdateFailed", arguments: ["reason": reason])
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
    
    func sendEvent(eventType: String, arguments: Dictionary<String, Any?>? = nil) {
        let eventDictionary: NSMutableDictionary = NSMutableDictionary()
        eventDictionary.setValue(eventType, forKey: "type")
        if let arguments = arguments {
            for (name, value) in arguments {
                if let value = value {
                    eventDictionary.setValue(value, forKey: name)
                }
            }
        }
        DispatchQueue.main.async {
            self.eventSink?(eventDictionary)
        }
    }

    // Request to execute a specific syncAcknowledged callback. It returns **true** if the API Event was sent, **false** otherwise.
    func executeSyncAcknowledgedCallback(index: Int) -> Bool {
        let eventWasSent: Bool? = syncReadyEventReferences[index]?.syncAcknowledged()
        clearSyncReadyEventReference(index: index)
        return eventWasSent ?? false
    }

    // Nullify a specific reference to a Sync Ready Event
    func clearSyncReadyEventReference(index: Int) {
        syncReadyEventReferences[index] = nil
    }

    // Nullify all the references to the Sync Ready Events
    func clearSyncReadyEventReferences() {
        syncReadyEventReferences = [:]
    }
}
