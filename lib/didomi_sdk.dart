import 'dart:async';

import 'package:flutter/services.dart';

class DidomiSdk {
  static const MethodChannel _channel = const MethodChannel('didomi_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> initialize(
      String apiKey,
      { String? localConfigurationPath = null,
        String? remoteConfigurationURL = null,
        String? providerId = null,
        bool disableDidomiRemoteConfig = false,
        String? languageCode = null,
        String? noticeId = null}
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
