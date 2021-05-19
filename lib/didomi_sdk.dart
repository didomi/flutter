import 'dart:async';

import 'events/events_handler.dart';
import 'package:flutter/services.dart';

import 'events/event_listener.dart';
import 'constants.dart';

class DidomiSdk {
  static const MethodChannel _channel = const MethodChannel(methodsChannelName);
  static EventsHandler _eventsHandler = EventsHandler();

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

  /// Check if Didomi SDK was successfully initialized
  static Future<bool> get isReady async {
    final bool result = await _channel.invokeMethod('isReady');
    return result;
  }

  /// Check if user consent are partial or not set
  static Future<bool> get shouldConsentBeCollected async {
    final bool result = await _channel.invokeMethod('shouldConsentBeCollected');
    return result;
  }

  /// Reset user consents
  static Future<void> reset() async {
    await _channel.invokeMethod('reset');
  }

  /// Show the preferences screen
  static Future<void> showPreferences() async {
    await _channel.invokeMethod('showPreferences');
  }

  /// Setup the UI and show the notice if needed
  static Future<void> setupUI() async {
    await _channel.invokeMethod('setupUI');
  }

  /// Hide the notice
  static Future<void> hideNotice() async {
    await _channel.invokeMethod('hideNotice');
  }

  /// Add listener to SDK events
  static addEventListener(EventListener listener) {
    _eventsHandler.addEventListener(listener);
  }

  /// Remove listener to SDK events
  static removeEventListener(EventListener listener) {
    _eventsHandler.removeEventListener(listener);
  }

  /// Provide a function to be called once SDK is ready.
  /// Automatically calls the function if SDK is already ready.
  static onReady(Function() callback) {
    _eventsHandler.onReadyCallbacks.add(callback);
    _channel.invokeMethod('onReady');
  }

  /// Provide a function to be called if SDK encounters an error
  static onError(Function() callback) {
    _eventsHandler.onErrorCallbacks.add(callback);
    _channel.invokeMethod('onError');
  }
}
