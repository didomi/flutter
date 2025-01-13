import Flutter
import UIKit
import Didomi

public class SwiftDidomiSdkPlugin: NSObject, FlutterPlugin {

    /// Default message if SDK is not ready
    private static let didomiNotReadyException: String = "Didomi SDK is not ready. Use the onReady callback to access this method."

    static var eventStreamHandler: DidomiEventStreamHandler? = nil
    private var vendorStatusListeners = Set<String>()

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
            shouldConsentBeCollected(result: result)
        case "shouldUserStatusBeCollected":
            shouldUserStatusBeCollected(result: result)
        case "isConsentRequired":
            isConsentRequired(result: result)
        case "isUserConsentStatusPartial":
            isUserConsentStatusPartial(result: result)
        case "isUserLegitimateInterestStatusPartial":
            isUserLegitimateInterestStatusPartial(result: result)
        case "isUserStatusPartial":
            isUserStatusPartial(result: result)
        case "reset":
            reset(result: result)
        case "setupUI":
            setupUI(result: result)
        case "showNotice":
            showNotice(result: result)
        case "hideNotice":
            hideNotice(result: result)
        case "isNoticeVisible":
            isNoticeVisible(result: result)
        case "showPreferences":
            showPreferences(call, result: result)
        case "hidePreferences":
            hidePreferences(result: result)
        case "isPreferencesVisible":
            isPreferencesVisible(result: result)
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
        case "getCurrentUserStatus":
            getCurrentUserStatus(result: result)
        case "setCurrentUserStatus":
            setCurrentUserStatus(call, result: result)
        case "getUserStatus":
            getUserStatus(result: result)
        case "getApplicableRegulation":
            getApplicableRegulation(result: result)
        case "getRequiredPurposeIds":
            getRequiredPurposeIds(result: result)
        case "getRequiredVendorIds":
            getRequiredVendorIds(result: result)
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
        case "setUserStatus":
            setUserStatus(call, result: result)
        case "setUserStatusGlobally":
            setUserStatusGlobally(call, result: result)
        case "clearUser":
            clearUser(call, result: result)
        case "setUser":
            setUser(call, result: result)
        case "setUserAndSetupUI":
            setUserAndSetupUI(call, result: result)
        case "setUserWithAuthParams":
            setUserWithAuthParams(call, result: result)
        case "setUserWithAuthParamsAndSetupUI":
            setUserWithAuthParamsAndSetupUI(call, result: result)
        case "listenToVendorStatus":
            listenToVendorStatus(call, result: result)
        case "stopListeningToVendorStatus":
            stopListeningToVendorStatus(call, result: result)
        case "commitCurrentUserStatusTransaction":
            commitCurrentUserStatusTransaction(call, result: result)
        case "executeSyncAcknowledgedCallback":
            executeSyncAcknowledgedCallback(call, result: result)
        case "getTotalVendorCount":
            getTotalVendorCount(result: result)
        case "getIabVendorCount":
            getIABVendorCount(result: result)
        case "getNonIabVendorCount":
            getNonIABVendorCount(result: result)

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
            noticeID: args["noticeId"] as? String,
            countryCode: args["countryCode"] as? String,
            regionCode: args["regionCode"] as? String,
            isUnderage: args["isUnderage"] as? Bool ?? false
        )
        Didomi.shared.initialize(parameters)
        result(nil)
    }

    func shouldConsentBeCollected(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.shouldConsentBeCollected())
    }

    func shouldUserStatusBeCollected(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.shouldUserStatusBeCollected())
    }

    func isConsentRequired(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.isConsentRequired())
    }

    func isUserLegitimateInterestStatusPartial(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.isUserLegitimateInterestStatusPartial())
    }

    func isUserConsentStatusPartial(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.isUserConsentStatusPartial())
    }

    func isUserStatusPartial(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.isUserStatusPartial())
    }
    
    func setupUI(result: @escaping FlutterResult) {
        if let viewController = UIApplication.shared.rootViewController {
            Didomi.shared.setupUI(containerController: viewController)
            result(nil)
        } else {
            result(FlutterError.init(code: "nil_root_view_controller", message: "Root view controller is nil", details: nil))
        }
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

    func hideNotice(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        Didomi.shared.hideNotice()
        result(nil)
    }

    func isNoticeVisible(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.isNoticeVisible())
    }

    func showPreferences(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }

        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for initialize", details: nil))
            return
        }

        let view: Didomi.Views
        let viewArgument = args["view"] as? String

        switch viewArgument {
        case "vendors":
            view = .vendors
        case "sensitive-personal-information":
            view = .sensitivePersonalInformation
        default:
            view = .purposes
        }

        if let viewController = UIApplication.shared.rootViewController {
            Didomi.shared.showPreferences(controller: viewController, view: view)
            result(nil)
        } else {
            result(FlutterError.init(code: "nil_root_view_controller", message: "Root view controller is nil", details: nil))
        }
    }

    func hidePreferences(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        Didomi.shared.hidePreferences()
        result(nil)
    }

    func isPreferencesVisible(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        result(Didomi.shared.isPreferencesVisible())
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
     * Get the current user status object
     - Returns: json describing the current user status
     */
    func getCurrentUserStatus(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let currentUserStatus = Didomi.shared.getCurrentUserStatus()
        let encoded = EntitiesHelper.dictionary(from: currentUserStatus)
        result(encoded)
    }

    /**
     * Set the current user status object
     - Returns: true if the status has been updated, false otherwise
     */
    func setCurrentUserStatus(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }

        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setCurrentUserStatus", details: nil))
            return
        }

        var purposes = [String: CurrentUserStatus.PurposeStatus]()
        let purposesDict = args["purposes"] as? [String: [String: Any]]
        purposesDict?.forEach { dict in
            guard let id = dict.value["id"] as? String,
                  let enabled = dict.value["enabled"] as? Bool else {
                return
            }
            purposes[dict.key] = CurrentUserStatus.PurposeStatus(id: id, enabled: enabled)
            return
        }

        var vendors = [String: CurrentUserStatus.VendorStatus]()
        let vendorsDict = args["vendors"] as? [String: [String: Any]]
        vendorsDict?.forEach { dict in
            guard let id = dict.value["id"] as? String,
                  let enabled = dict.value["enabled"] as? Bool else {
                return
            }
            vendors[dict.key] = CurrentUserStatus.VendorStatus(id: id, enabled: enabled)
            return
        }

        result(
            Didomi.shared.setCurrentUserStatus(
                currentUserStatus: CurrentUserStatus(
                    purposes: purposes,
                    vendors: vendors
                )
            )
        )
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
     * Get the applicable regulation
     - Returns: applicable regulation
     */
    func getApplicableRegulation(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let regulation = Didomi.shared.applicableRegulation.description
        result(regulation)
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

    func clearUser(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftDidomiSdkPlugin.eventStreamHandler?.clearSyncReadyEventReferences()
        Didomi.shared.clearUser()
        result(nil)
    }

    func setUser(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setUser", details: nil))
            return
        }

        guard let userId = argumentOrError(argumentName: "organizationUserId", methodName: "setUser", args: args, result: result) else {
            return
        }

        let isUnderage = args["isUnderage"] as? Bool

        if let isUnderage = isUnderage {
            Didomi.shared.setUser(id: userId, isUnderage: isUnderage)
        } else {
            Didomi.shared.setUser(id: userId)
        }
        result(nil)
    }

    func setUserAndSetupUI(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for setUser", details: nil))
            return
        }

        guard let userId = argumentOrError(argumentName: "organizationUserId", methodName: "setUser", args: args, result: result) else {
            return
        }

        let isUnderage = args["isUnderage"] as? Bool

        if let viewController: UIViewController = UIApplication.shared.rootViewController {
            if let isUnderage = isUnderage {
                Didomi.shared.setUser(id: userId, isUnderage: isUnderage, containerController: viewController)
            } else {
                Didomi.shared.setUser(id: userId, containerController: viewController)
            }
        } else if let isUnderage = isUnderage {
            Didomi.shared.setUser(id: userId, isUnderage: isUnderage)
        } else {
            Didomi.shared.setUser(id: userId)
        }

        result(nil)
    }

    private func buildUserAuthParams(jsonParameters: [String: Any]) -> UserAuthParams {

        guard let id = jsonParameters["id"] as? String,
              let algorithm = jsonParameters["algorithm"] as? String,
              let secretID = jsonParameters["secretId"] as? String else {
            fatalError("Missing required parameters")
        }

        let expiration = jsonParameters["expiration"] as? CLong
        let initializationVector = jsonParameters["initializationVector"] as? String
        let digest = jsonParameters["digest"] as? String
        let salt = jsonParameters["salt"] as? String

        if let initializationVector = initializationVector {
            if let expiration = expiration {
                return UserAuthWithEncryptionParams(
                    id: id,
                    algorithm: algorithm,
                    secretID: secretID,
                    initializationVector: initializationVector,
                    legacyExpiration: Double(expiration)
                )
            } else {
                return UserAuthWithEncryptionParams(
                    id: id,
                    algorithm: algorithm,
                    secretID: secretID,
                    initializationVector: initializationVector
                )
            }
        } else {
            guard let digest = digest else {
                fatalError("Missing required digest parameter")
            }
            if let expiration = expiration {
                return UserAuthWithHashParams(
                    id: id,
                    algorithm: algorithm,
                    secretID: secretID,
                    digest: digest,
                    salt: salt,
                    legacyExpiration: Double(expiration)
                )
            } else {
                return UserAuthWithHashParams(
                    id: id,
                    algorithm: algorithm,
                    secretID: secretID,
                    digest: digest,
                    salt: salt
                )
            }
        }
    }

    func setUserWithAuthParams(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError(code: "setUser", message: "Missing parameters", details: nil))
            return
        }

        guard let jsonUserAuthParams = args["jsonUserAuthParams"] as? Dictionary<String, Any> else {
            result(FlutterError(code: "setUserWithAuthParams", message: "Missing jsonUserAuthParams", details: nil))
            return
        }

        let jsonSynchronizedUsers = args["jsonSynchronizedUsers"] as? [[String: Any]]
        let isUnderage = args["isUnderage"] as? Bool

        let userAuthParams = buildUserAuthParams(jsonParameters: jsonUserAuthParams)
        let synchronizedUsers = jsonSynchronizedUsers?.map { buildUserAuthParams(jsonParameters: $0) }

        if let synchronizedUsers = synchronizedUsers {
            if let isUnderage = isUnderage {
                Didomi.shared.setUser(userAuthParams: userAuthParams, synchronizedUsers: synchronizedUsers, isUnderage: isUnderage)
            } else {
                Didomi.shared.setUser(userAuthParams: userAuthParams, synchronizedUsers: synchronizedUsers)
            }
        } else if let isUnderage = isUnderage {
            Didomi.shared.setUser(userAuthParams: userAuthParams, isUnderage: isUnderage)
        } else {
            Didomi.shared.setUser(userAuthParams: userAuthParams)
        }

        result(nil)
    }

    func setUserWithAuthParamsAndSetupUI(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError(code: "setUser", message: "Missing parameters", details: nil))
            return
        }

        guard let jsonUserAuthParams = args["jsonUserAuthParams"] as? Dictionary<String, Any> else {
            result(FlutterError(code: "setUserWithAuthParams", message: "Missing jsonUserAuthParams", details: nil))
            return
        }

        let jsonSynchronizedUsers = args["jsonSynchronizedUsers"] as? [[String: Any]]
        let isUnderage = args["isUnderage"] as? Bool

        let userAuthParams = buildUserAuthParams(jsonParameters: jsonUserAuthParams)
        let synchronizedUsers = jsonSynchronizedUsers?.map { buildUserAuthParams(jsonParameters: $0) }

        if let viewController: UIViewController = UIApplication.shared.rootViewController {
            if let synchronizedUsers = synchronizedUsers {
                if let isUnderage = isUnderage {
                    Didomi.shared.setUser(userAuthParams: userAuthParams, synchronizedUsers: synchronizedUsers, isUnderage: isUnderage, containerController: viewController)
                } else {
                    Didomi.shared.setUser(userAuthParams: userAuthParams, synchronizedUsers: synchronizedUsers, containerController: viewController)
                }
            } else if let isUnderage = isUnderage {
                Didomi.shared.setUser(userAuthParams: userAuthParams, isUnderage: isUnderage, containerController: viewController)
            } else {
                Didomi.shared.setUser(userAuthParams: userAuthParams, containerController: viewController)
            }
        } else if let synchronizedUsers = synchronizedUsers {
            if let isUnderage = isUnderage {
               Didomi.shared.setUser(userAuthParams: userAuthParams, synchronizedUsers: synchronizedUsers, isUnderage: isUnderage)
            } else {
               Didomi.shared.setUser(userAuthParams: userAuthParams, synchronizedUsers: synchronizedUsers)
            }
       } else if let isUnderage = isUnderage {
           Didomi.shared.setUser(userAuthParams: userAuthParams, isUnderage: isUnderage)
       } else {
           Didomi.shared.setUser(userAuthParams: userAuthParams)
       }

        result(nil)
    }

    func listenToVendorStatus(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for listenToVendorStatus", details: nil))
            return
        }

        guard let vendorId = argumentOrError(argumentName: "vendorId", methodName: "listenToVendorStatus", args: args, result: result) else {
            return
        }
        
        if !vendorStatusListeners.contains(vendorId) {
            Didomi.shared.addVendorStatusListener(id: vendorId) { vendorStatus in
                let encoded = EntitiesHelper.dictionary(from: vendorStatus)
                SwiftDidomiSdkPlugin.eventStreamHandler?.sendEvent(eventType: "onVendorStatusChanged", arguments: ["vendorStatus": encoded])
            }
            vendorStatusListeners.insert(vendorId)
        }
        result(nil)
    }

    func stopListeningToVendorStatus(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for stopListeningToVendorStatus", details: nil))
            return
        }

        guard let vendorId = argumentOrError(argumentName: "vendorId", methodName: "stopListeningToVendorStatus", args: args, result: result) else {
            return
        }
        
        if vendorStatusListeners.contains(vendorId) {
            vendorStatusListeners.remove(vendorId)
            Didomi.shared.removeVendorStatusListener(id: vendorId)
        }
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

    /// Receives all the modified status related to vendors and purposes and passes them to a new native transaction.
    /// Then it calls the `commit` method of this newly created transaction which saves these changes into the user status.
    func commitCurrentUserStatusTransaction(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, [String]> else {
            result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for commitCurrentUserStatusTransaction", details: nil))
            return
        }

        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        
        let updated = Didomi.shared.openCurrentUserStatusTransaction()
            .enablePurposes(args["enabledPurposes"] ?? [])
            .disablePurposes(args["disabledPurposes"] ?? [])
            .enableVendors(args["enabledVendors"] ?? [])
            .disableVendors(args["disabledVendors"] ?? [])
            .commit()
        
        result(updated)
    }

    /// Execute the syncAcknowledgedCallback method of the Didomi SDK
    func executeSyncAcknowledgedCallback(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            guard let args = call.arguments as? Dictionary<String, Int>,
                  let syncReadyEventIndex = args["syncReadyEventIndex"] else {
                result(FlutterError.init(code: "invalid_args", message: "Wrong arguments for executeSyncAcknowledgedCallback", details: nil))
                return
            }

        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }

        let eventWasSent = SwiftDidomiSdkPlugin.eventStreamHandler?.executeSyncAcknowledgedCallback(index: syncReadyEventIndex) ?? false
        result(eventWasSent)
    }
    
    // Get total vendor count.
    func getTotalVendorCount(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let count = Didomi.shared.getTotalVendorCount()
        result(count)
    }
    
    // Get IAB vendor count.
    func getIABVendorCount(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let count = Didomi.shared.getIABVendorCount()
        result(count)
    }
    
    // Get non-IAB vendor count.
    func getNonIABVendorCount(result: @escaping FlutterResult) {
        if !Didomi.shared.isReady() {
            result(FlutterError.init(code: "sdk_not_ready", message: SwiftDidomiSdkPlugin.didomiNotReadyException, details: nil))
            return
        }
        let count = Didomi.shared.getNonIABVendorCount()
        result(count)
    }
}

extension UIApplication {
    // Computed property to get the root view controller of the application
    var rootViewController: UIViewController? {
        if let viewController = UIApplication.shared.delegate?.window??.rootViewController {
            return viewController
        }
        if let viewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            return viewController
        }
        return nil
    }
}
