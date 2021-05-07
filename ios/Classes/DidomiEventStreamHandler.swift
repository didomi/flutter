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
    }
        
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
        
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    func sendEvent(eventType: String) {
        eventSink?("{\"type\":\"\(eventType)\"}")
    }
}
