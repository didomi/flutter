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
            getDisabledPurposeIds(result: result)
        case "getDisabledVendorIds":
            getDisabledVendorIds(result: result)
        case "getEnabledPurposeIds":
            getEnabledPurposeIds(result: result)
        case "getEnabledVendorIds":
            getEnabledVendorIds(result: result)
        case "getRequiredPurposeIds":
            getRequiredPurposeIds(result: result)
        case "getRequiredVendorIds":
            getRequiredVendorIds(result: result)
        case "setLogLevel":
            setLogLevel(call, result: result)
        case "setUserAgreeToAll":
            setUserAgreeToAll(result: result)
        case "setUserDisagreeToAll":
            setUserDisagreeToAll(result: result)
        case "getUserConsentStatusForPurpose":
            getUserConsentStatusForPurpose(call, result: result)
        case "getUserConsentStatusForVendor":
            getUserConsentStatusForVendor(call, result: result)
        case "getUserConsentStatusForVendorAndRequiredPurposes":
            getUserConsentStatusForVendorAndRequiredPurposes(call, result: result)
        case "setUserStatus":
            setUserStatus(call, result: result)
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
     - Returns: Array of purpose ids
     */
    func getDisabledPurposeIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getDisabledPurposeIds()))
    }

    /**
     * Get the disabled vendor IDs
     - Returns: Array of vendor ids
     */
    func getDisabledVendorIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getDisabledVendorIds()))
    }

    /**
     * Get the enabled purpose IDs
     - Returns: Array of purpose ids
     */
    func getEnabledPurposeIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getEnabledPurposeIds()))
    }

    /**
     * Get the enabled vendor IDs
     - Returns: Array of vendor ids
     */
    func getEnabledVendorIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getEnabledVendorIds()))
    }

    /**
     * Get the required purpose IDs
     - Returns: Array of purpose ids
     */
    func getRequiredPurposeIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getRequiredPurposeIds()))
    }

    /**
     * Get the required vendor IDs
     - Returns: Array of vendor ids
     */
    func getRequiredVendorIds(result: @escaping FlutterResult) {
        result(Array(Didomi.shared.getRequiredVendorIds()))
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
        guard let args = call.arguments as? Dictionary<String, UInt8> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setLogLevel", details: nil))
                return
            }
        Didomi.shared.setLogLevel(minLevel: args["minLevel"] ?? 1)
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

    /**
     Get the user consent status for a specific purpose
     - Parameter purposeId: The purpose ID to check consent for
     - Returns: The user consent status for the specified purpose
     */
    func getUserConsentStatusForPurpose(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, String> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getUserConsentStatusForPurpose", details: nil))
                return
            }

        let purposeId = args["purposeId"] ?? ""
        if purposeId.isEmpty {
            result(FlutterError.init(code: "invalid_args", message: "Missing purposeId argument for getUserConsentStatusForPurpose", details: nil))
            return
        }

        let consentStatusForPurpose = Didomi.shared.getUserConsentStatusForPurpose(purposeId: purposeId)
        switch consentStatusForPurpose {
        case .disable:
          result(0)
        case .enable:
          result(1)
        default:
          result(2)
        }
    }

    /**
     Get the user consent status for a specific vendor
     - Parameter vendorId: The vendor ID to check consent for
     - Returns: The user consent status for the specified vendor
     */
    func getUserConsentStatusForVendor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, String> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getUserStatusForVendor", details: nil))
                return
            }

        let vendorId = args["vendorId"] ?? ""
        if vendorId.isEmpty {
            result(FlutterError.init(code: "invalid_args", message: "Missing vendorId argument for getUserStatusForVendor", details: nil))
            return
        }

        let consentStatusForVendor = Didomi.shared.getUserConsentStatusForVendor(vendorId: vendorId)
        switch consentStatusForVendor {
        case .disable:
          result(0)
        case .enable:
          result(1)
        default:
          result(2)
        }
    }

    /**
     Get the user consent status for a specific vendor and all its purposes
     - Parameter vendorId: The ID of the vendor
     - Returns: The user consent status corresponding to the specified vendor and all its required purposes
     */
    func getUserConsentStatusForVendorAndRequiredPurposes(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, String> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getUserConsentStatusForVendorAndRequiredPurposes", details: nil))
                return
            }

        let vendorId = args["vendorId"] ?? ""
        if vendorId.isEmpty {
            result(FlutterError.init(code: "invalid_args", message: "Missing vendorId argument for getUserConsentStatusForVendorAndRequiredPurposes", details: nil))
            return
        }

        let consentStatusForVendor = Didomi.shared.getUserConsentStatusForVendorAndRequiredPurposes(vendorId: vendorId)
        switch consentStatusForVendor {
        case .disable:
          result(0)
        case .enable:
          result(1)
        default:
          result(2)
        }
    }

    /**
     Set the user status for purposes and vendors for consent and legitimate interest.
     - Parameters purposesConsentStatus: boolean used to determine if consent will be enabled or disabled for all purposes.
     - Parameters purposesLIStatus: boolean used to determine if legitimate interest will be enabled or disabled for all purposes.
     - Parameters vendorsConsentStatus: boolean used to determine if consent will be enabled or disabled for all vendors.
     - Parameters vendorsLIStatus: boolean used to determine if legitimate interest will be enabled or disabled for all vendors.
     - Returns: **true** if consent status has been updated, **false** otherwise.
     */
    func setUserStatus(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Bool> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setUserStatus", details: nil))
                return
            }

        result(Didomi.shared.setUserStatus(
            purposesConsentStatus: args["purposesConsentStatus"] ?? false,
            purposesLIStatus: args["purposesLIStatus"] ?? false,
            vendorsConsentStatus: args["vendorsConsentStatus"] ?? false,
            vendorsLIStatus: args["vendorsLIStatus"] ?? false
        ))
    }
}
