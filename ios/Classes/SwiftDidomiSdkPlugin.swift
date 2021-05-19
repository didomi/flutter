import Flutter
import UIKit
import Didomi

public class SwiftDidomiSdkPlugin: NSObject, FlutterPlugin {
    
    static var eventStreamHandler: DidomiEventStreamHandler? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: Constants.methodsChannelName, binaryMessenger: registrar.messenger())
        let instance = SwiftDidomiSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventStreamHandler = DidomiEventStreamHandler()
        SwiftDidomiSdkPlugin.eventStreamHandler = eventStreamHandler
        Didomi.shared.addEventListener(listener: eventStreamHandler.eventListener)

        let eventChannel = FlutterEventChannel(name: Constants.eventsChannelName, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(eventStreamHandler)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "initialize":
            initialize(call, result: result)
        case "isReady":
            result(Didomi.shared.isReady())
        case "onReady":
            Didomi.shared.onReady {
                SwiftDidomiSdkPlugin.eventStreamHandler?.onReadyCallback()
            }
        case "onError":
            Didomi.shared.onError { _ in
                SwiftDidomiSdkPlugin.eventStreamHandler?.onErrorCallback()
            }
        case "shouldConsentBeCollected":
            result(Didomi.shared.shouldConsentBeCollected())
        case "setupUI":
            setupUI(result: result)
        case "reset":
            Didomi.shared.reset()
            result(nil)
        case "showPreferences":
            showPreferences(result: result)
        case "hideNotice":
            Didomi.shared.hideNotice()
            result(nil)
        case "getJavaScriptForWebView":
            result(Didomi.shared.getJavaScriptForWebView())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func initialize(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for initialize", details: nil))
            return
        }
        guard let apiKey = args["apiKey"] as? String else {
            result(FlutterError.init(code: "invalid_args", message: "Missing argument apiKey", details: nil))
            return
        }
        guard let disableDidomiRemoteConfig = args["disableDidomiRemoteConfig"] as? Bool else {
            result(FlutterError.init(code: "invalid_args", message: "Missing argument disableDidomiRemoteConfig", details: nil))
            return
        }
        let didomi = Didomi.shared
        didomi.initialize(
            apiKey: apiKey,
            localConfigurationPath: args["localConfigurationPath"] as? String ?? nil,
            remoteConfigurationURL: args["remoteConfigurationURL"] as? String ?? nil,
            providerId: args["providerId"] as? String ?? nil,
            disableDidomiRemoteConfig: disableDidomiRemoteConfig,
            languageCode: args["languageCode"] as? String ?? nil,
            noticeId: args["noticeId"] as? String ?? nil)
        result(nil)
    }
    
    func setupUI(result: @escaping FlutterResult) {
        let viewController: UIViewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!
        Didomi.shared.setupUI(containerController: viewController)
        result(nil)
    }
    
    func showPreferences(result: @escaping FlutterResult) {
        let viewController: UIViewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!
        Didomi.shared.showPreferences(controller: viewController)
        result(nil)
    }
}
