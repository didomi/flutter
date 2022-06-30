import Flutter
import UIKit
import Didomi

public class SwiftDidomiSdkPlugin: NSObject, FlutterPlugin {

    /// Default message if SDK is not ready
    private static let didomiNotReadyException: String = "Didomi SDK is not ready. Use the onReady callback to access this method."

    static var eventStreamHandler: DidomiEventStreamHandler? = nil
    
    override init() {
        super.init()
        
        if let userAgentVersion = Constants.userAgentVersion {
            Didomi.shared.setUserAgent(name: Constants.userAgentName, version: userAgentVersion)
        }
    }
    
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
        case "isConsentRequired":
            result(Didomi.shared.isConsentRequired())
        case "isUserConsentStatusPartial":
            result(Didomi.shared.isUserConsentStatusPartial())
        case "isUserLegitimateInterestStatusPartial":
            result(Didomi.shared.isUserLegitimateInterestStatusPartial())
        case "reset":
            reset(result: result)
        case "setupUI":
            setupUI(result: result)
        case "showNotice":
            showNotice(result: result)
        case "hideNotice":
            Didomi.shared.hideNotice()
            result(nil)
        case "isNoticeVisible":
            result(Didomi.shared.isNoticeVisible())
        case "showPreferences":
            showPreferences(call, result: result)
        case "hidePreferences":
            Didomi.shared.hidePreferences()
            result(nil)
        case "isPreferencesVisible":
            result(Didomi.shared.isPreferencesVisible())
        case "getJavaScriptForWebView":
            getJavaScriptForWebView(result: result)
        case "getQueryStringForWebView":
            result(Didomi.shared.getQueryStringForWebView())
        case "updateSelectedLanguage":
            updateSelectedLanguage(call, result: result)
        case "getText":
            getText(call, result: result)
        case "getTranslatedText":
            getTranslatedText(call, result: result)
        case "getUserStatus":
            getUserStatus(result: result)
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
        case "getEnabledPurposes":
            getEnabledPurposes(result: result)
        case "getDisabledPurposes":
            getDisabledPurposes(result: result)
        case "getEnabledVendors":
            getEnabledVendors(result: result)
        case "getDisabledVendors":
            getDisabledVendors(result: result)
        case "getRequiredPurposes":
            getRequiredPurposes(result: result)
        case "getRequiredVendors":
            getRequiredVendors(result: result)
        case "getPurpose":
            getPurpose(call, result: result)
        case "getVendor":
            getVendor(call, result: result)
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
        case "getUserLegitimateInterestStatusForPurpose":
            getUserLegitimateInterestStatusForPurpose(call, result: result)
        case "getUserLegitimateInterestStatusForVendor":
            getUserLegitimateInterestStatusForVendor(call, result: result)
        case "getUserLegitimateInterestStatusForVendorAndRequiredPurposes":
            getUserLegitimateInterestStatusForVendorAndRequiredPurposes(call, result: result)
        case "getUserStatusForVendor":
            getUserStatusForVendor(call, result: result)
        case "setUserStatus":
            setUserStatus(call, result: result)
        case "setUserStatusGlobally":
            setUserStatusGlobally(call, result: result)
        case "setUser":
            setUser(call, result: result)
        case "setUserWithHashAuthentication":
            setUserWithHashAuthentication(call, result: result)
        case "setUserWithEncryptionAuthentication":
            setUserWithEncryptionAuthentication(call, result: result)
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
            result(FlutterError.init(code: "invalid_args", message: "initialize: Missing argument apiKey", details: nil))
            return
        }
        guard let disableDidomiRemoteConfig = args["disableDidomiRemoteConfig"] as? Bool else {
            result(FlutterError.init(code: "invalid_args", message: "initialize: Missing argument disableDidomiRemoteConfig", details: nil))
            return
        }
        
        let parameters = DidomiInitializeParameters(
            apiKey: apiKey,
            localConfigurationPath: args["localConfigurationPath"] as? String,
            remoteConfigurationURL: args["remoteConfigurationURL"] as? String,
            providerID: args["providerId"] as? String,
            disableDidomiRemoteConfig: disableDidomiRemoteConfig,
            languageCode: args["languageCode"] as? String,
            noticeID: args["noticeId"] as? String)
        Didomi.shared.initialize(parameters)
        result(nil)
    }
    
    func setupUI(result: @escaping FlutterResult) {
        let viewController: UIViewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!
        Didomi.shared.setupUI(containerController: viewController)
        result(nil)
    }

    func reset(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        Didomi.shared.reset()
        result(nil)
    }

    func showNotice(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        Didomi.shared.showNotice()
        result(nil)
    }

    func showPreferences(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let viewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for initialize", details: nil))
            return
        }
        let view: Didomi.Views
        if let viewArgument = args["view"] as? String, viewArgument == "vendors" {
            view = .vendors
        } else {
            view = .purposes
        }
        Didomi.shared.showPreferences(controller: viewController, view: view)
        result(nil)
    }

    func updateSelectedLanguage(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for updateSelectedLanguage", details: nil))
            return
        }
        guard let languageCode = args["languageCode"] as? String else {
            result(FlutterError.init(code: "invalid_args", message: "updateSelectedLanguage: Missing argument languageCode", details: nil))
            return
        }
        Didomi.shared.updateSelectedLanguage(languageCode: languageCode)
        result(nil)
    }

    func getText(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getText", details: nil))
            return
        }
        guard let key = args["key"] as? String else {
            result(FlutterError.init(code: "invalid_args", message: "getText: Missing argument key", details: nil))
            return
        }
        result(Didomi.shared.getText(key: key))
    }

    func getTranslatedText(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getTranslatedText", details: nil))
            return
        }
        guard let key = args["key"] as? String else {
            result(FlutterError.init(code: "invalid_args", message: "getTranslatedText: Missing argument key", details: nil))
            return
        }
        result(Didomi.shared.getTranslatedText(key: key))
    }

    /**
     * Get the JavaScript For WebView
     - Returns: String
     */
    func getJavaScriptForWebView(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.getJavaScriptForWebView())
    }

    /**
     * Get the user status object
     - Returns: json describing the user status
     */
    func getUserStatus(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let userStatus = Didomi.shared.getUserStatus()
        let encoded = EntitiesHelper.dictionary(from: userStatus)
        result(encoded)
    }

    
    /**
     * Get the disabled purpose IDs
     - Returns: Array of purpose ids
     */
    func getDisabledPurposeIds(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let purposeIdList = Array(Didomi.shared.getDisabledPurposeIds())
        result(purposeIdList)
    }

    /**
     * Get the disabled vendor IDs
     - Returns: Array of vendor ids
     */
    func getDisabledVendorIds(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let vendorIdList = Array(Didomi.shared.getDisabledVendorIds())
        result(vendorIdList)
    }

    /**
     * Get the enabled purpose IDs
     - Returns: Array of purpose ids
     */
    func getEnabledPurposeIds(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let purposeIdList = Array(Didomi.shared.getEnabledPurposeIds())
        result(purposeIdList)
    }

    /**
     * Get the enabled vendor IDs
     - Returns: Array of vendor ids
     */
    func getEnabledVendorIds(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let vendorIdList = Array(Didomi.shared.getEnabledVendorIds())
        result(vendorIdList)
    }

    /**
     * Get the required purpose IDs
     - Returns: Array of purpose ids
     */
    func getRequiredPurposeIds(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let purposeIdList = Array(Didomi.shared.getRequiredPurposeIds())
        result(purposeIdList)
    }

    /**
     * Get the required vendor IDs
     - Returns: Array of vendor ids
     */
    func getRequiredVendorIds(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let vendorIdList = Array(Didomi.shared.getRequiredVendorIds())
        result(vendorIdList)
    }
    
    // Get enabled purposes from native to flutter.
    func getEnabledPurposes(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let purposes = Didomi.shared.getEnabledPurposes()
        let encoded = EntitiesHelper.dictionaries(from: purposes)
        result(encoded)
    }
    
    // Get disabled purposes from native to flutter.
    func getDisabledPurposes(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let purposes = Didomi.shared.getDisabledPurposes()
        let encoded = EntitiesHelper.dictionaries(from: purposes)
        result(encoded)
    }
    
    // Get enabled vendors from native to flutter.
    func getEnabledVendors(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let vendors = Didomi.shared.getEnabledVendors()
        let encoded = EntitiesHelper.dictionaries(from: vendors)
        result(encoded)
    }
    
    // Get disabled vendors from native to flutter.
    func getDisabledVendors(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let vendors = Didomi.shared.getDisabledVendors()
        let encoded = EntitiesHelper.dictionaries(from: vendors)
        result(encoded)
    }
    
    // Get required purposes from native to flutter.
    func getRequiredPurposes(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let purposes = Didomi.shared.getRequiredPurposes()
        let encoded = EntitiesHelper.dictionaries(from: purposes)
        result(encoded)
    }
    
    // Get required vendors from native to flutter.
    func getRequiredVendors(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let vendors = Didomi.shared.getRequiredVendors()
        let encoded = EntitiesHelper.dictionaries(from: vendors)
        result(encoded)
    }
    
    // Get a purpose based on its ID from native to flutter.
    func getPurpose(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getPurpose", details: nil))
            return
        }
        
        guard let purposeID = args["purposeId"] as? String else {
            result(FlutterError.init(code: "invalid_args", message: "getPurpose: Missing argument purposeID", details: nil))
            return
        }
        
        let purpose = Didomi.shared.getPurpose(purposeId: purposeID)
        let encoded = EntitiesHelper.dictionary(from: purpose)
        result(encoded)
    }
    
    // Get a vendor based on its ID from native to flutter.
    func getVendor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getVendor", details: nil))
            return
        }
        
        guard let vendorID = args["vendorId"] as? String else {
            result(FlutterError.init(code: "invalid_args", message: "getVendor: Missing argument vendorID", details: nil))
            return
        }
        
        let vendor = Didomi.shared.getVendor(vendorId: vendorID)
        let encoded = EntitiesHelper.dictionary(from: vendor)
        result(encoded)
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
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.setUserAgreeToAll())
    }

    /**
     Method that allows to disable consent and legitimate interest for all the required purposes and vendors.
     - Returns: **true** if consent status has been updated, **false** otherwise.
     */
    func setUserDisagreeToAll(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.setUserDisagreeToAll())
    }

    /**
     Get the user consent status for a specific purpose
     - Parameter purposeId: The purpose ID to check consent for
     - Returns: The user consent status for the specified purpose
     */
    func getUserConsentStatusForPurpose(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
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
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
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
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
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
     Get the user legitimate interest status for a specific purpose
     - Parameter purposeId: The purpose ID to check consent for
     - Returns: The user legitimate interest status for the specified purpose
     */
    func getUserLegitimateInterestStatusForPurpose(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, String> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getUserLegitimateInterestStatusForPurpose", details: nil))
                return
            }

        let purposeId = args["purposeId"] ?? ""
        if purposeId.isEmpty {
            result(FlutterError.init(code: "invalid_args", message: "Missing purposeId argument for getUserLegitimateInterestStatusForPurpose", details: nil))
            return
        }

        let legitimateInterestStatusForPurpose = Didomi.shared.getUserLegitimateInterestStatusForPurpose(purposeId: purposeId)
        switch legitimateInterestStatusForPurpose {
        case .disable:
          result(0)
        case .enable:
          result(1)
        default:
          result(2)
        }
    }

    /**
     Get the user legitimate interest status for a specific vendor
     - Parameter vendorId: The vendor ID to check consent for
     - Returns: The user consent status for the specified vendor
     */
    func getUserLegitimateInterestStatusForVendor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, String> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getUserLegitimateInterestStatusForVendor", details: nil))
                return
            }

        let vendorId = args["vendorId"] ?? ""
        if vendorId.isEmpty {
            result(FlutterError.init(code: "invalid_args", message: "Missing vendorId argument for getUserLegitimateInterestStatusForVendor", details: nil))
            return
        }

        let legitimateInterestStatusForVendor = Didomi.shared.getUserLegitimateInterestStatusForVendor(vendorId: vendorId)
        switch legitimateInterestStatusForVendor {
        case .disable:
          result(0)
        case .enable:
          result(1)
        default:
          result(2)
        }
    }

    /**
     Get the user status (consent and legitimate interest) for a specific vendor
     - Parameter vendorId: The vendor ID to check consent for
     - Returns: The user status for the specified vendor
     */
    func getUserStatusForVendor(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, String> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getUserStatusForVendor", details: nil))
                return
            }

        let vendorId = args["vendorId"] ?? ""
        if vendorId.isEmpty {
            result(FlutterError.init(code: "invalid_args", message: "Missing vendorId argument for getUserStatusForVendor", details: nil))
            return
        }

        let statusForVendor = Didomi.shared.getUserStatusForVendor(vendorId: vendorId)
        switch statusForVendor {
        case .disable:
          result(0)
        case .enable:
          result(1)
        default:
          result(2)
        }
    }

    /**
     Get the user legitimate interest status for a specific vendor and all its purposes
     - Parameter vendorId: The ID of the vendor
     - Returns: The user legitimate interest status corresponding to the specified vendor and all its required purposes
     */
    func getUserLegitimateInterestStatusForVendorAndRequiredPurposes(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, String> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for getUserLegitimateInterestStatusForVendorAndRequiredPurposes", details: nil))
                return
            }

        let vendorId = args["vendorId"] ?? ""
        if vendorId.isEmpty {
            result(FlutterError.init(code: "invalid_args", message: "Missing vendorId argument for getUserLegitimateInterestStatusForVendorAndRequiredPurposes", details: nil))
            return
        }

        let legitimateInterestStatusForVendor = Didomi.shared.getUserLegitimateInterestStatusForVendorAndRequiredPurposes(vendorId: vendorId)
        switch legitimateInterestStatusForVendor {
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
     - Parameters enabledConsentPurposeIds: List of enabled consent purposes to set.
     - Parameters disabledConsentPurposeIds: List of disabled consent purposes to set.
     - Parameters enabledLIPurposeIds: List of enabled legitimate interest purposes to set.
     - Parameters disabledLIPurposeIds: List of disabled legitimate interest purposes to set.
     - Parameters enabledConsentVendorIds: List of enabled consent vendors to set.
     - Parameters disabledConsentVendorIds: List of disabled consent vendors to set.
     - Parameters enabledLIVendorIds: List of enabled legitimate interest vendors to set.
     - Parameters disabledLIVendorIds: List of disabled legitimate interest vendors to set.
     - Returns: **true** if consent status has been updated, **false** otherwise.
     */
    func setUserStatus(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, Array<String>> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setUserStatus", details: nil))
                return
            }

        result(Didomi.shared.setUserStatus(
                enabledConsentPurposeIds: arrayArgToSet(args: args, key: "enabledConsentPurposeIds"),
                disabledConsentPurposeIds: arrayArgToSet(args: args, key: "disabledConsentPurposeIds"),
                enabledLIPurposeIds: arrayArgToSet(args: args, key: "enabledLIPurposeIds"),
                disabledLIPurposeIds: arrayArgToSet(args: args, key: "disabledLIPurposeIds"),
                enabledConsentVendorIds: arrayArgToSet(args: args, key: "enabledConsentVendorIds"),
                disabledConsentVendorIds: arrayArgToSet(args: args, key: "disabledConsentVendorIds"),
                enabledLIVendorIds: arrayArgToSet(args: args, key: "enabledLIVendorIds"),
                disabledLIVendorIds: arrayArgToSet(args: args, key: "disabledLIVendorIds"))
        )
    }
    
    func arrayArgToSet(args: Dictionary<String, Array<String>>, key: String) -> Set<String> {
        if let array = args[key] {
            return Set(array)
        }
        return Set()
    }
    
    /**
     Set the global user status for purposes and vendors for consent and legitimate interest.
     - Parameters purposesConsentStatus: boolean used to determine if consent will be enabled or disabled for all purposes.
     - Parameters purposesLIStatus: boolean used to determine if legitimate interest will be enabled or disabled for all purposes.
     - Parameters vendorsConsentStatus: boolean used to determine if consent will be enabled or disabled for all vendors.
     - Parameters vendorsLIStatus: boolean used to determine if legitimate interest will be enabled or disabled for all vendors.
     - Returns: **true** if consent status has been updated, **false** otherwise.
     */
    func setUserStatusGlobally(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        guard let args = call.arguments as? Dictionary<String, Bool> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setUserStatusGlobally", details: nil))
                return
            }

        result(Didomi.shared.setUserStatus(
            purposesConsentStatus: args["purposesConsentStatus"] ?? false,
            purposesLIStatus: args["purposesLIStatus"] ?? false,
            vendorsConsentStatus: args["vendorsConsentStatus"] ?? false,
            vendorsLIStatus: args["vendorsLIStatus"] ?? false
        ))
    }

    func setUser(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setUser", details: nil))
                return
            }

        guard let userId = argumentOrError(argumentName: "organizationUserId", methodName: "setUser", args: args, result: result) else {
            return
        }
        Didomi.shared.setUser(id: userId)
        result(nil)
    }

    func setUserWithHashAuthentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setUserWithHashAuthentication", details: nil))
                return
            }

        guard let userId = argumentOrError(argumentName: "organizationUserId", methodName: "setUserWithHashAuthentication", args: args, result: result) else {
            return
        }
        guard let algorithm = argumentOrError(argumentName: "algorithm", methodName: "setUserWithHashAuthentication", args: args, result: result) else {
            return
        }
        guard let secretId = argumentOrError(argumentName: "secretId", methodName: "setUserWithHashAuthentication", args: args, result: result) else {
            return
        }
        guard let digest = argumentOrError(argumentName: "digest", methodName: "setUserWithHashAuthentication", args: args, result: result) else {
            return
        }
        let salt = args["salt"] as? String
        let parameters: UserAuthWithHashParams
        if let expiration = args["expiration"] as? CLong {
            parameters = UserAuthWithHashParams(
                id: userId,
                algorithm: algorithm,
                secretID: secretId,
                digest: digest,
                salt: salt,
                legacyExpiration: Double(expiration))
        } else {
            parameters = UserAuthWithHashParams(
                id: userId,
                algorithm: algorithm,
                secretID: secretId,
                digest: digest,
                salt: salt)
        }
        Didomi.shared.setUser(userAuthParams: parameters)
        result(nil)
    }
    
    func setUserWithEncryptionAuthentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setUserWithEncryptionAuthentication", details: nil))
                return
            }

        guard let userId = argumentOrError(argumentName: "organizationUserId", methodName: "setUserWithEncryptionAuthentication", args: args, result: result) else {
            return
        }
        guard let algorithm = argumentOrError(argumentName: "algorithm", methodName: "setUserWithEncryptionAuthentication", args: args, result: result) else {
            return
        }
        guard let secretId = argumentOrError(argumentName: "secretId", methodName: "setUserWithEncryptionAuthentication", args: args, result: result) else {
            return
        }
        guard let initializationVector = argumentOrError(argumentName: "initializationVector", methodName: "setUserWithEncryptionAuthentication", args: args, result: result) else {
            return
        }
        let parameters: UserAuthWithEncryptionParams
        if let expiration = args["expiration"] as? CLong {
            parameters = UserAuthWithEncryptionParams(
                id: userId,
                algorithm: algorithm,
                secretID: secretId,
                initializationVector: initializationVector,
                legacyExpiration: Double(expiration))
        } else {
            parameters = UserAuthWithEncryptionParams(
                id: userId,
                algorithm: algorithm,
                secretID: secretId,
                initializationVector: initializationVector)
        }
        Didomi.shared.setUser(userAuthParams: parameters)
        result(nil)
    }

    /// Return the requested argument as non-empty String, or raise an error in result and return null
    private func argumentOrError(argumentName: String, methodName: String, args: Dictionary<String, Any>, result: FlutterResult) -> String? {
        let argument = args[argumentName] as? String ?? ""
        if argument.isEmpty {
            result(FlutterError.init(code: "invalid_args", message: "Missing \(argumentName) argument for \(methodName)", details: nil))
            return nil
        }
        return argument
    }
}
