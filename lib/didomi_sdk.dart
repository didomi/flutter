import 'dart:io';
import 'dart:async';

import 'package:didomi_sdk/entities/entities_helper.dart';
import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk/entities/user_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'consent_status.dart';
import 'entities/vendor.dart';
import 'log_level.dart';
import 'preferences_view.dart';
import 'constants.dart';
import 'events/event_listener.dart';
import 'events/events_handler.dart';

/// Didomi SDK Plugin
class DidomiSdk {
  static const MethodChannel _channel = const MethodChannel(methodsChannelName);
  static EventsHandler _eventsHandler = EventsHandler();

  /// Initialize the SDK
  static Future<void> initialize(String apiKey,
      {String? localConfigurationPath,
        String? remoteConfigurationURL,
        String? providerId,
        bool disableDidomiRemoteConfig = false,
        String? languageCode,
        String? noticeId}) async =>
    await _channel.invokeMethod("initialize", {
      "apiKey": apiKey,
      "localConfigurationPath": localConfigurationPath,
      "remoteConfigurationURL": remoteConfigurationURL,
      "providerId": providerId,
      "disableDidomiRemoteConfig": disableDidomiRemoteConfig,
      "languageCode": languageCode,
      "noticeId": noticeId
    });

  /// Check if Didomi SDK was successfully initialized
  static Future<bool> get isReady async => await _channel.invokeMethod('isReady');

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
  static Future<void> hidePreferences() async => await _channel.invokeMethod("hidePreferences");

  /// Check if preferences screen is visible
  static Future<bool> get isPreferencesVisible async =>
    await _channel.invokeMethod('isPreferencesVisible');

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
  static Future<String> get javaScriptForWebView async =>
    await _channel.invokeMethod("getJavaScriptForWebView");

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
  static Future<void> updateSelectedLanguage(String languageCode) async =>
    await _channel.invokeMethod("updateSelectedLanguage", {"languageCode": languageCode});

  /// Get a dictionary/map for a given key in the form of { en: "Value in English", fr: "Value in French" }
  /// from the didomi_config.json file containing translations in different languages.
  ///
  /// The keys and values considered come from different places in the didomi_config.json file such as { notice: ... },
  /// { preferences: ... } and { texts: ... }, giving the latter the highest priority in case of duplicates.
  static Future<Map<String, String>?> getText(String key) async =>
      await _channel.invokeMapMethod("getText", {"key": key});

  /// Get a translated string for a given key from the didomi_config.json file based on the currently selected language.
  /// 
  /// The keys and values considered come from different places in the didomi_config.json file such as { notice: ... },
  /// { preferences: ... } and { texts: ... }, giving the latter the highest priority in case of duplicates.
  static Future<String> getTranslatedText(String key) async =>
      await _channel.invokeMethod("getTranslatedText", {"key": key});

  /// Get the user consent status as a UserStatus object
  static Future<UserStatus> get userStatus async {
    final dynamic result = await _channel.invokeMethod("getUserStatus");
    return UserStatus.fromJson(result);
  }

  /// Get the IDs of the disabled purposes
  @Deprecated("Use userStatus instead. "
      "Search for the purposeId in userStatus.purposes.global.disabled or userStatus.purposes.consent.disabled")
  static Future<List<String>> get disabledPurposeIds async {
    final List<dynamic> result = await _channel.invokeMethod('getDisabledPurposeIds');
    return result.cast();
  }

  /// Get the IDs of the disabled vendors
  @Deprecated("Use userStatus instead. "
      "The result of this method has been replaced by userStatus.vendors.consent.disabled.")
  static Future<List<String>> get disabledVendorIds async {
    final List<dynamic> result = await _channel.invokeMethod('getDisabledVendorIds');
    return result.cast();
  }

  /// Get the IDs of the enabled purposes
  @Deprecated("Use userStatus instead. "
      "Search for the purposeId in userStatus.purposes.global.enabled or userStatus.purposes.consent.disabled")
  static Future<List<String>> get enabledPurposeIds async {
    final List<dynamic> result = await _channel.invokeMethod('getEnabledPurposeIds');
    return result.cast();
  }

  /// Get the IDs of the enabled vendors
  @Deprecated("Use userStatus instead. "
      "The result of this method has been replaced by userStatus.vendors.consent.enabled")
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

  /// Get enabled purposes.
  @Deprecated("Use userStatus instead. "
      "The result of this method has been replaced by userStatus.purposes.global.enabled")
  static Future<List<Purpose>> get enabledPurposes async {
    final List<dynamic> result = await _channel.invokeMethod("getEnabledPurposes");
    return EntitiesHelper.toPurposes(result);
  }

  /// Get disabled purposes.
  @Deprecated("Use userStatus instead. "
      "The result of this method has been replaced by userStatus.purposes.global.disabled")
  static Future<List<Purpose>> get disabledPurposes async {
    final List<dynamic> result = await _channel.invokeMethod("getDisabledPurposes");
    return EntitiesHelper.toPurposes(result);
  }

  /// Get enabled vendors.
  @Deprecated("Use userStatus instead. "
      "The result of this method has been replaced by userStatus.vendors.consent.enabled")
  static Future<List<Vendor>> get enabledVendors async {
    final List<dynamic> result = await _channel.invokeMethod("getEnabledVendors");
    return EntitiesHelper.toVendors(result);
  }

  /// Get disabled vendors.
  @Deprecated("Use userStatus instead. "
      "The result of this method has been replaced by userStatus.vendors.consent.disabled")
  static Future<List<Vendor>> get disabledVendors async {
    final List<dynamic> result = await _channel.invokeMethod("getDisabledVendors");
    return EntitiesHelper.toVendors(result);
  }

  /// Get required purposes.
  static Future<List<Purpose>> get requiredPurposes async {
    final List<dynamic> result = await _channel.invokeMethod("getRequiredPurposes");
    return EntitiesHelper.toPurposes(result);
  }

  /// Get required vendors.
  static Future<List<Vendor>> get requiredVendors async {
    final List<dynamic> result = await _channel.invokeMethod("getRequiredVendors");
    return EntitiesHelper.toVendors(result);
  }

  /// Get a purpose by its id.
  static Future<Purpose?> getPurpose(String purposeId) async {
    final dynamic result = await _channel.invokeMethod("getPurpose", { "purposeId": purposeId });
    if (result == null) return null;
    return Purpose.fromJson(result);
  }

  /// Get a vendor by its id.
  static Future<Vendor?> getVendor(String vendorId) async {
    final dynamic result = await _channel.invokeMethod("getVendor", { "vendorId": vendorId });
    if (result == null) return null;
    return Vendor.fromJson(result);
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
  @Deprecated("Use userStatus instead. "
      "Search for the purposeId in userStatus.purposes.global.enabled or userStatus.purposes.consent.disabled")
  static Future<ConsentStatus> getUserConsentStatusForPurpose(String purposeId) async {
    final int result = await _channel.invokeMethod("getUserConsentStatusForPurpose", {"purposeId": purposeId});
    return ConsentStatus.values[result];
  }

  /// Get the user consent status for a specific vendor
  @Deprecated("Use userStatus instead. "
      "Search for the vendorId in userStatus.vendors.global.enabled or userStatus.vendors.global.disabled")
  static Future<ConsentStatus> getUserConsentStatusForVendor(String vendorId) async {
    final int result = await _channel.invokeMethod("getUserConsentStatusForVendor", {"vendorId": vendorId});
    return ConsentStatus.values[result];
  }

  /// Get the user consent status for a specific vendor and all its purposes
  @Deprecated("Use userStatus instead. "
      "Search for the vendorId in userStatus.vendors.globalConsent.enabled or userStatus.vendors.globalConsent.disabled")
  static Future<ConsentStatus> getUserConsentStatusForVendorAndRequiredPurposes(String vendorId) async {
    final int result = await _channel.invokeMethod("getUserConsentStatusForVendorAndRequiredPurposes", {"vendorId": vendorId});
    return ConsentStatus.values[result];
  }


  /// Get the user legitimate interest status for a specific purpose
  @Deprecated("Use userStatus instead. "
      "Search for the purposeId in userStatus.purposes.global.enabled or userStatus.purposes.legitimateInterest.disabled")
  static Future<ConsentStatus> getUserLegitimateInterestStatusForPurpose(String purposeId) async {
    final int result = await _channel.invokeMethod("getUserLegitimateInterestStatusForPurpose", {"purposeId": purposeId});
    return ConsentStatus.values[result];
  }

  /// Get the user legitimate interest status for a specific vendor
  @Deprecated("Use userStatus instead. "
      "Search for the vendorId in userStatus.vendors.global.enabled or userStatus.vendors.global.disabled")
  static Future<ConsentStatus> getUserLegitimateInterestStatusForVendor(String vendorId) async {
    final int result = await _channel.invokeMethod("getUserLegitimateInterestStatusForVendor", {"vendorId": vendorId});
    return ConsentStatus.values[result];
  }

  /// Get the user legitimate interest status for a specific vendor and all its purposes
  @Deprecated("Use userStatus instead. "
      "Search for the vendorId in userStatus.vendors.globalLegitimateInterest.enabled or userStatus.vendors.globalLegitimateInterest.disabled")
  static Future<ConsentStatus> getUserLegitimateInterestStatusForVendorAndRequiredPurposes(String vendorId) async {
    final int result = await _channel.invokeMethod("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", {"vendorId": vendorId});
    return ConsentStatus.values[result];
  }

  /// Get the user consent and legitimate interest status for a specific vendor
  @Deprecated("Use userStatus instead. "
      "Search for the vendorId in userStatus.vendors.global.enabled or userStatus.vendors.global.disabled")
  static Future<ConsentStatus> getUserStatusForVendor(String vendorId) async {
    final int result = await _channel.invokeMethod("getUserStatusForVendor", {"vendorId": vendorId});
    return ConsentStatus.values[result];
  }

  /// Set the user status globally
  static Future<bool> setUserStatusGlobally(bool purposesConsentStatus, bool purposesLIStatus, bool vendorsConsentStatus, bool vendorsLIStatus) async =>
    await _channel.invokeMethod("setUserStatusGlobally", {
      "purposesConsentStatus": purposesConsentStatus,
      "purposesLIStatus": purposesLIStatus,
      "vendorsConsentStatus": vendorsConsentStatus,
      "vendorsLIStatus": vendorsLIStatus
    });

  /// Set the user status
  static Future<bool> setUserStatus(
      List<String> enabledConsentPurposeIds,
      List<String> disabledConsentPurposeIds,
      List<String> enabledLIPurposeIds,
      List<String> disabledLIPurposeIds,
      List<String> enabledConsentVendorIds,
      List<String> disabledConsentVendorIds,
      List<String> enabledLIVendorIds,
      List<String> disabledLIVendorIds
      ) async =>
      await _channel.invokeMethod("setUserStatus", {
        "enabledConsentPurposeIds": enabledConsentPurposeIds,
        "disabledConsentPurposeIds": disabledConsentPurposeIds,
        "enabledLIPurposeIds": enabledLIPurposeIds,
        "disabledLIPurposeIds": disabledLIPurposeIds,
        "enabledConsentVendorIds": enabledConsentVendorIds,
        "disabledConsentVendorIds": disabledConsentVendorIds,
        "enabledLIVendorIds": enabledLIVendorIds,
        "disabledLIVendorIds": disabledLIVendorIds
      });

  /// Set user information
  static Future<void> setUser(String organizationUserId) async =>
    await _channel.invokeMethod("setUser", {
      "organizationUserId": organizationUserId
    });

  /// Set user information with authentication
  static Future<void> setUserWithAuthentication(
      String organizationUserId,
      String organizationUserIdAuthAlgorithm,
      String organizationUserIdAuthSid,
      String? organizationUserIdAuthSalt,
      String organizationUserIdAuthDigest
      ) async =>
    await _channel.invokeMethod("setUserWithAuthentication", {
      "organizationUserId": organizationUserId,
      "organizationUserIdAuthAlgorithm": organizationUserIdAuthAlgorithm,
      "organizationUserIdAuthSid": organizationUserIdAuthSid,
      "organizationUserIdAuthSalt": organizationUserIdAuthSalt,
      "organizationUserIdAuthDigest": organizationUserIdAuthDigest
    });
}
