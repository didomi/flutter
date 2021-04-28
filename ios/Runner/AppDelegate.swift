import UIKit
import Flutter
import Didomi

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let didomi = Didomi.shared
    didomi.initialize(apiKey: "564aff4d-2d11-480b-97b5-8b5d80f72cb6", localConfigurationPath: nil, remoteConfigurationURL: nil, providerId: nil)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "flutter_plugin_test",
                                              binaryMessenger: controller.binaryMessenger)
    
    didomi.setupUI(containerController: controller)
    didomi.onReady {
        didomi.reset()
    }
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "getShouldConsentBeCollected" {
            
        } else if call.method == "resetDidomi" {
            didomi.reset()
            result(1)
            return
        } else if call.method == "showPreferences" {
            didomi.showPreferences()
            result(1)
            return
        }
        self.sendMessageBack(result: result)
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func sendMessageBack(result: FlutterReply) {
        result(Didomi.shared.shouldConsentBeCollected())
    }
}
