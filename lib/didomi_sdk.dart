import 'dart:io';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'consent_status.dart';
import 'log_level.dart';
import 'preferences_view.dart';
import 'constants.dart';
import 'events/event_listener.dart';
import 'events/events_handler.dart';

/// Didomi SDK Plugin
class DidomiSdk {
  static const MethodChannel _channel = const MethodChannel(methodsChannelName);
  static EventsHandler _eventsHandler = EventsHandler();

  // TODO To remove
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod("getPlatformVersion");
    return version;
  }

  /// Initialize the SDK
  static Future<void> initialize(String apiKey,
      {String? localConfigurationPath,
        String? remoteConfigurationURL,
        String? providerId,
        bool disableDidomiRemoteConfig = false,
        String? languageCode,
        String? noticeId}) async {
    return await _channel.invokeMethod("initialize", {
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

  /// Determine if consent is required for the user. The rules are (OR):
  /// - The user country is in the EU
  /// - The company is from the EU
  /// - The user country is unknown and the app has chosen to collect consent when unknown
  static Future<bool> get isConsentRequired async {
    final bool result = await _channel.invokeMethod('isConsentRequired');
    return result;
  }

  /// Determine if consent information is available for all purposes and vendors that are required
  static Future<bool> get isUserConsentStatusPartial async {
    final bool result = await _channel.invokeMethod('isUserConsentStatusPartial');
    return result;
  }

  /// Determine if legitimate interest information is available for all purposes and vendors that are required
  static Future<bool> get isUserLegitimateInterestStatusPartial async {
    final bool result = await _channel.invokeMethod('isUserLegitimateInterestStatusPartial');
    return result;
  }

  /// Reset user consents
  static Future<void> reset() async {
    await _channel.invokeMethod('reset');
  }

  /// Setup the UI and show the notice if needed
  static Future<void> setupUI() async {
    await _channel.invokeMethod('setupUI');
  }

  /// Show the notice screen if user consent is needed.
  /// Note: When calling from iOS, setupUI must have been called before.
  static Future<void> showNotice() async {
    await _channel.invokeMethod("showNotice");
  }

  /// Hide the notice
  static Future<void> hideNotice() async {
    await _channel.invokeMethod('hideNotice');
  }

  /// Check if notice is visible
  static Future<bool> get isNoticeVisible async {
    final bool result = await _channel.invokeMethod('isNoticeVisible');
    return result;
  }

  /// Show the preferences screen
  static Future<void> showPreferences({PreferencesView view = PreferencesView.purposes}) async {
    await _channel.invokeMethod("showPreferences", {
      "view": describeEnum(view)
    });
  }

  /// Hide the preferences screen
  static Future<void> hidePreferences() async {
    await _channel.invokeMethod("hidePreferences");
  }

  /// Check if preferences screen is visible
  static Future<bool> get isPreferencesVisible async {
    final bool result = await _channel.invokeMethod('isPreferencesVisible');
    return result;
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

  /// Get JavaScript to embed into a WebView to pass the consent status
  /// from the app to the Didomi Web SDK embedded into the WebView
  static Future<String> get javaScriptForWebView async {
    final String result = await _channel.invokeMethod("getJavaScriptForWebView");
    return result;
  }

  /// Get a query-string to add to the URL of a WebView or Chrome Custom Tab to pass
  /// the consent status from the app to the Didomi Web SDK embedded on the target URL.
  /// Note: Available for Android only, will return an empty string if called from iOS
  static Future<String> get queryStringForWebView async {
    final String result;
    if (Platform.isAndroid) {
      result = await _channel.invokeMethod("getQueryStringForWebView");
    } else {
      // Not available on iOS
      result = "";
    }
    return result;
  }

  /// Method used to update the selected language of the Didomi SDK and any property that depends on it.
  ///
  /// In most cases this method doesn't need to be called. It would only be required for those apps that allow language change on-the-fly,
  /// i.e.: from within the app rather than from the device settings.
  /// In order to update the language of the views displayed by the Didomi SDK, this method needs to be called before these views are displayed.
  static Future<void> updateSelectedLanguage(String languageCode) async {
    await _channel.invokeMethod("updateSelectedLanguage", {"languageCode": languageCode});
  }

  /// Get a dictionary/map for a given key in the form of { en: "Value in English", fr: "Value in French" }
  /// from the didomi_config.json file containing translations in different languages.
  ///
  /// The keys and values considered come from different places in the didomi_config.json file such as { notice: ... },
  /// { preferences: ... } and { texts: ... }, giving the latter the highest priority in case of duplicates.
  static Future<Map<String, String>?> getText(String key) async {
    Map<String, String>? result = await _channel.invokeMapMethod("getText", {"key": key});
    return result;
  }

  /// Get a translated string for a given key from the didomi_config.json file based on the currently selected language.
  /// 
  /// The keys and values considered come from different places in the didomi_config.json file such as { notice: ... },
  /// { preferences: ... } and { texts: ... }, giving the latter the highest priority in case of duplicates.
  static Future<String> getTranslatedText(String key) async {
    String result = await _channel.invokeMethod("getTranslatedText", {"key": key});
    return result;
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

  /// Get the user consent status for a specific purpose
  static Future<ConsentStatus> getUserConsentStatusForPurpose(String purposeId) async {
    final int result = await _channel.invokeMethod("getUserConsentStatusForPurpose", {"purposeId": purposeId});
    return ConsentStatus.values[result];
  }

  /// Get the user consent status for a specific vendor
  static Future<ConsentStatus> getUserConsentStatusForVendor(String vendorId) async {
    final int result = await _channel.invokeMethod("getUserConsentStatusForVendor", {"vendorId": vendorId});
    return ConsentStatus.values[result];
  }

  /// Get the user consent status for a specific vendor and all its purposes
  static Future<ConsentStatus> getUserConsentStatusForVendorAndRequiredPurposes(String vendorId) async {
    final int result = await _channel.invokeMethod("getUserConsentStatusForVendorAndRequiredPurposes", {"vendorId": vendorId});
    return ConsentStatus.values[result];
  }

  /// Set the user status globally
  static Future<bool> setUserStatus(bool purposesConsentStatus, bool purposesLIStatus, bool vendorsConsentStatus, bool vendorsLIStatus) async {
    final bool result = await _channel.invokeMethod("setUserStatus", {
      "purposesConsentStatus": purposesConsentStatus,
      "purposesLIStatus": purposesLIStatus,
      "vendorsConsentStatus": vendorsConsentStatus,
      "vendorsLIStatus": vendorsLIStatus
    });
    return result;
  }

}
