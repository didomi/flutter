
import 'dart:async';

import 'package:flutter/services.dart';

class DidomiSdk {
  static const MethodChannel _channel =
      const MethodChannel('didomi_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> get initialize async {
    final bool result = await _channel.invokeMethod('initialize');
    return result;
  }

  static Future<bool> get getShouldConsentBeCollected async {
    final bool result = await _channel.invokeMethod('getShouldConsentBeCollected');
    return result;
  }

  static Future<void> get resetDidomi async {
    await _channel.invokeMethod('resetDidomi');
  }

  static Future<void> get showPreferences async {
    await _channel.invokeMethod('showPreferences');
  }

  static Future<void> get setupUI async {
    return await _channel.invokeMethod('setupUI');
  }
}
