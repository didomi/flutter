import 'dart:async';

import 'package:didomi_sdk/consent_status.dart';
import 'events/events_handler.dart';
import 'package:didomi_sdk/log_level.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'events/event_listener.dart';

class DidomiSdk {
  static const MethodChannel _channel = const MethodChannel(methodsChannelName);
  static EventsHandler _eventsHandler = EventsHandler();

  // TODO To remove
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> initialize(String apiKey,
      {String? localConfigurationPath,
      String? remoteConfigurationURL,
      String? providerId,
      bool disableDidomiRemoteConfig = false,
      String? languageCode,
      String? noticeId}) async {
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

  /// Get the IDs of the disabled purposes
  static Future<List<String>> get disabledPurposeIds async {
    final List<dynamic> result = await _channel.invokeMethod('getDisabledPurposeIds');
    return result.cast();
  }

  /// Get the IDs of the disabled vendors
  static Future<List<String>> get disabledVendorIds async {
    final List<dynamic> result = await _channel.invokeMethod('getDisabledVendorIds');
    return result.cast();
  }

  /// Get the IDs of the enabled purposes
  static Future<List<String>> get enabledPurposeIds async {
    final List<dynamic> result = await _channel.invokeMethod('getEnabledPurposeIds');
    return result.cast();
  }

  /// Get the IDs of the enabled vendors
  static Future<List<String>> get enabledVendorIds async {
    final List<dynamic> result = await _channel.invokeMethod('getEnabledVendorIds');
    return result.cast();
  }

  /// Get the IDs of the required purposes
  static Future<List<String>> get requiredPurposeIds async {
    final List<dynamic> result = await _channel.invokeMethod('getRequiredPurposeIds');
    return result.cast();
  }

  /// Get the IDs of the required vendors
  static Future<List<String>> get requiredVendorIds async {
    final List<dynamic> result = await _channel.invokeMethod('getRequiredVendorIds');
    return result.cast();
  }

  /// Set the minimum level of messages to log
  static setLogLevel(LogLevel minLevel) {
    _channel.invokeMethod("setLogLevel", {"minLevel": minLevel.platformLevel});
  }

  /// Enable all purposes and vendors for the user.
  static Future<bool> setUserAgreeToAll() async {
    final bool result = await _channel.invokeMethod("setUserAgreeToAll");
    return result;
  }

  /// Update user status to disagree : disable consent and legitimate interest purposes, disable consent vendors, but still enable legitimate interest vendors.
  static Future<bool> setUserDisagreeToAll() async {
    final bool result = await _channel.invokeMethod("setUserDisagreeToAll");
    return result;
  }

  /// Get the user consent status for a specific vendor
  static Future<ConsentStatus> getUserConsentStatusForVendor(String vendorId) async {
    final int result = await _channel.invokeMethod("getUserConsentStatusForVendor", {"vendorId": vendorId});
    return ConsentStatus.values[result];
  }

  /// Set the user status globally
  static Future<bool> setUserStatus(
      bool purposesConsentStatus,
      bool purposesLIStatus,
      bool vendorsConsentStatus,
      bool vendorsLIStatus
      ) async {
    final bool result = await _channel.invokeMethod("setUserStatus", {
      "purposesConsentStatus": purposesConsentStatus,
      "purposesLIStatus": purposesLIStatus,
      "vendorsConsentStatus": vendorsConsentStatus,
      "vendorsLIStatus": vendorsLIStatus
    });
    return result;
  }
}
