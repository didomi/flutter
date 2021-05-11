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
        
        eventListener.onShowNotice = { [unowned self] event in
            self.sendEvent(eventType: "onShowNotice")
        }
        eventListener.onHideNotice = { [unowned self] event in
            self.sendEvent(eventType: "onHideNotice")
        }
        eventListener.onReady = { [unowned self] event in
            self.sendEvent(eventType: "onReady")
        }
        eventListener.onError = { [unowned self] event in
            self.sendEvent(eventType: "onError", message: event.descriptionText)
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
    
    func sendEvent(eventType: String, message: String? = nil) {
        let eventDictionary: NSMutableDictionary = NSMutableDictionary()
        eventDictionary.setValue(eventType, forKey: "type")
        if let message = message {
            eventDictionary.setValue(message, forKey: "message")
        }
        if let jsonEvent = try? JSONSerialization.data(withJSONObject: eventDictionary) {
            let jsonString = String(data: jsonEvent, encoding: String.Encoding.utf8)
            eventSink?(jsonString)
        }
    }
}
