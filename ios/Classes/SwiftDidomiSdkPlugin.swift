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
        case "getDisabledPurposeIds":
            getDisabledPurposeIds(call, result: result)
        case "getDisabledVendorIds":
            getDisabledVendorIds(call, result: result)
        case "getEnabledPurposeIds":
            getEnabledPurposeIds(call, result: result)
        case "getEnabledVendorIds":
            getEnabledVendorIds(call, result: result)
        case "getRequiredPurposeIds":
            getRequiredPurposeIds(call, result: result)
        case "getRequiredVendorIds":
            getRequiredVendorIds(call, result: result)
        case "setLogLevel":
            setLogLevel(call, result: result)
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

    /**
     * Get the disabled purpose IDs
     */
    func getDisabledPurposeIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getDisabledPurposeIds))
    }

    /**
     * Get the disabled vendor IDs
     */
    func getDisabledVendorIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getDisabledVendorIds))
    }

    /**
     * Get the enabled purpose IDs
     */
    func getEnabledPurposeIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getEnabledPurposeIds))
    }

    /**
     * Get the enabled vendor IDs
     */
    func getEnabledVendorIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getEnabledVendorIds))
    }

    /**
     * Get the required purpose IDs
     */
    func getRequiredPurposeIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getRequiredPurposeIds))
    }

    /**
     * Get the required vendor IDs
     */
    func getRequiredVendorIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getRequiredVendorIds))
    }

    /**
     Set the minimum level of messages to log

     Messages with a level below `minLevel` will not be logged.
     Levels are standard levels from `OSLogType` (https://developer.apple.com/documentation/os/logging/choosing_the_log_level_for_a_message):
      - OSLogType.info (1)
      - OSLogType.debug (2)
      - OSLogType.error (16)
      - OSLogType.fault (17)

     We recommend setting `OSLogType.error` (16) in production
     */
    func setLogLevel(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Int> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setLogLevel", details: nil))
                return
            }
        Didomi.shared.setLogLevel(minLevel: args["minLevel"] as? UInt8 ?? 1)
        result(nil)
    }

    /**
     Method that allows to enable consent and legitimate interest for all the required purposes.
     - Returns: **true** if consent status has been updated, **false** otherwise.
     */
    func setUserAgreeToAll(result: @escaping FlutterResult) {
        result(Didomi.shared.setUserAgreeToAll())
    }

    /**
     Method that allows to disable consent and legitimate interest for all the required purposes and vendors.
     - Returns: **true** if consent status has been updated, **false** otherwise.
     */
    func setUserDisagreeToAll(result: @escaping FlutterResult) {
        result(Didomi.shared.setUserDisagreeToAll())
    }
}
