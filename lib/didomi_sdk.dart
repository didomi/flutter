import 'dart:async';

import 'package:flutter/services.dart';

class DidomiSdk {
  static const MethodChannel _channel = const MethodChannel('didomi_sdk');

  // TODO To remove
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> initialize(
      String apiKey,
      { String? localConfigurationPath,
        String? remoteConfigurationURL,
        String? providerId,
        bool disableDidomiRemoteConfig = false,
        String? languageCode,
        String? noticeId}
        ) async {
    return await _channel.invokeMethod('initialize', {
      "apiKey": apiKey,
      "localConfigurationPath": localConfigurationPath,
      "remoteConfigurationURL": remoteConfigurationURL,
      "providerId": providerId,
      "disableDidomiRemoteConfig": disableDidomiRemoteConfig,
      "languageCode": languageCode,
      "noticeId": noticeId
    });
  }

  static Future<bool> get isReady async {
    final bool result = await _channel.invokeMethod('isReady');
    return result;
  }

  static Future<bool> get shouldConsentBeCollected async {
    final bool result = await _channel.invokeMethod('shouldConsentBeCollected');
    return result;
  }

  static Future<void> reset() async {
    await _channel.invokeMethod('reset');
  }

  static Future<void> showPreferences() async {
    await _channel.invokeMethod('showPreferences');
  }

  static Future<void> setupUI() async {
    return await _channel.invokeMethod('setupUI');
  }
}
