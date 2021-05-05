import Flutter
import UIKit
import Didomi

public class SwiftDidomiSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "didomi_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftDidomiSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "initialize":
            initialize(call, result: result)
        case "shouldConsentBeCollected":
            result(Didomi.shared.shouldConsentBeCollected())
        case "setupUI":
            setupUI(result: result)
        case "reset":
            Didomi.shared.reset()
            result(nil)
        case "showPreferences":
            showPreferences(result: result)
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
