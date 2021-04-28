
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPluginTest {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_test');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> get getShouldConsentBeCollected async {
    final bool result = await _channel.invokeMethod('getShouldConsentBeCollected');
    return result;
  }

  static Future<bool> get resetDidomi async {
    final bool result = await _channel.invokeMethod('resetDidomi');
    return result;
  }

  static Future<bool> get showPreferences async {
    final bool result = await _channel.invokeMethod('showPreferences');
    return result;
  }
}
