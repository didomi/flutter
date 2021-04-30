import Flutter
import UIKit
//import Didomi

public class SwiftDidomiSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "didomi_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftDidomiSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion") {
        result("iOS " + UIDevice.current.systemVersion)
    //} else if (call.method == "initialize") {
    //    let didomi = Didomi.shared
    //    didomi.initialize(apiKey: "564aff4d-2d11-480b-97b5-8b5d80f72cb6", localConfigurationPath: nil, remoteConfigurationURL: nil, providerId: nil)
    //    result(true)
    //} else if (call.method == "getShouldConsentBeCollected") {
    //    result(Didomi.shared.getShouldConsentBeCollected())
    }
  }
}
