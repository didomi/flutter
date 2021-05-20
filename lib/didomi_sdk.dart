import 'dart:io';

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

  /// Get JavaScript to embed into a WebView to pass the consent status
  /// from the app to the Didomi Web SDK embedded into the WebView
  static Future<String> getJavaScriptForWebView() async {
    final String result = await _channel.invokeMethod("getJavaScriptForWebView");
    return result;
  }

  /// Get a query-string to add to the URL of a WebView or Chrome Custom Tab to pass
  /// the consent status from the app to the Didomi Web SDK embedded on the target URL.
  /// Note: Available for Android only, will return an empty string if called from iOS
  static Future<String> getQueryStringForWebView() async {
    final String result;
    if (Platform.isAndroid) {
      result = await _channel.invokeMethod(
          "getQueryStringForWebView");
    }  else {
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
    await _channel.invokeMethod("updateSelectedLanguage", {
      "languageCode": languageCode
    });
  }

  /// Get a dictionary/map for a given key in the form of { en: "Value in English", fr: "Value in French" }
  /// from the didomi_config.json file containing translations in different languages.
  ///
  /// The keys and values considered come from different places in the didomi_config.json file such as { notice: ... },
  /// { preferences: ... } and { texts: ... }, giving the latter the highest priority in case of duplicates.
  static Future<Map<String, String>?> getText(String key) async {
    Map<String, String>? result = await _channel.invokeMapMethod("getText", {
      "key": key
    });
    return result;
  }

  /// Get a translated string for a given key from the didomi_config.json file based on the currently selected language.
  /// 
  /// The keys and values considered come from different places in the didomi_config.json file such as { notice: ... },
  /// { preferences: ... } and { texts: ... }, giving the latter the highest priority in case of duplicates.
  static Future<String> getTranslatedText(String key) async {
    String result = await _channel.invokeMethod("getTranslatedText", {
      "key": key
    });
    return result;
  }
}
