import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';

/// Helper to listen to all SDK events and trigger callback to UI
class EventsHelper {

  EventListener didomiListener = EventListener();
  dynamic Function(String eventDescription)? uiCallback;

  EventsHelper() {

    didomiListener.onReady = () {
      onEvent("SDK Ready");
    };
    didomiListener.onError = (message) {
      onEvent("Error : $message");
    };
    didomiListener.onShowNotice = () {
      onEvent("Notice displayed");
    };
    didomiListener.onHideNotice = () {
      onEvent("Notice hidden");
    };
    didomiListener.onShowPreferences = () {
      onEvent("Preferences screen displayed");
    };
    didomiListener.onHidePreferences = () {
      onEvent("Preferences screen hidden");
    };
    didomiListener.onNoticeClickAgree = () {
      onEvent("Click Agree from Notice");
    };
    didomiListener.onNoticeClickDisagree = () {
      onEvent("Click Disagree from Notice");
    };
    didomiListener.onNoticeClickViewVendors = () {
      onEvent("Click View vendors from Notice");
    };
    didomiListener.onNoticeClickMoreInfo = () {
      onEvent("Click More info from Notice");
    };
    didomiListener.onNoticeClickPrivacyPolicy = () {
      onEvent("Click Privacy policy from Notice");
    };
    didomiListener.onPreferencesClickAgreeToAll = () {
      onEvent("Click Agree to all from Preferences");
    };
    didomiListener.onPreferencesClickDisagreeToAll = () {
      onEvent("Click Disagree to all from Preferences");
    };
    didomiListener.onPreferencesClickPurposeAgree = (purposeId) {
      onEvent("Click Agree to purpose $purposeId from Preferences");
    };
    didomiListener.onPreferencesClickPurposeDisagree = (purposeId) {
      onEvent("Click Disagree to purpose $purposeId from Preferences");
    };
    didomiListener.onPreferencesClickCategoryAgree = (categoryId) {
      onEvent("Click Agree to category $categoryId from Preferences");
    };
    didomiListener.onPreferencesClickCategoryDisagree = (categoryId) {
      onEvent("Click Disagree to category $categoryId from Preferences");
    };
    didomiListener.onPreferencesClickPurposeAgree = (purposeId) {
      onEvent("Click Agree to $purposeId from Preferences");
    };
    didomiListener.onPreferencesClickViewVendors = () {
      onEvent("Click View vendors from Preferences");
    };
    didomiListener.onPreferencesClickSaveChoices = () {
      onEvent("Click Save choices from Preferences");
    };
    didomiListener.onPreferencesClickVendorAgree = (vendorId) {
      onEvent("Click Agree to vendor $vendorId from Preferences");
    };
    didomiListener.onPreferencesClickVendorDisagree = (vendorId) {
      onEvent("Click Disagree to vendor $vendorId from Preferences");
    };
    didomiListener.onPreferencesClickVendorSaveChoices = () {
      onEvent("Click Save vendor choices from Preferences");
    };
    didomiListener.onPreferencesClickViewPurposes = () {
      onEvent("Click View purposes from Preferences");
    };
    didomiListener.onConsentChanged = () {
      onEvent("Consent has changed");
    };
    didomiListener.onPreferencesClickAgreeToAllPurposes = () {
      onEvent("Click Agree to all purposes from Preferences");
    };
    didomiListener.onPreferencesClickDisagreeToAllPurposes = () {
      onEvent("Click Disagree to all purposes from Preferences");
    };
    didomiListener.onPreferencesClickResetAllPurposes = () {
      onEvent("Click Reset all purposes from Preferences");
    };
    didomiListener.onPreferencesClickAgreeToAllVendors = () {
      onEvent("Click Agree to all vendors from Preferences");
    };
    didomiListener.onPreferencesClickDisagreeToAllVendors = () {
      onEvent("Click Disagree to all vendors from Preferences");
    };
    didomiListener.onSyncDone = (organizationUserId) {
      onEvent("Sync has been done for user $organizationUserId");
    };
    didomiListener.onSyncError = (error) {
      onEvent("Sync failed with error $error");
    };
    didomiListener.onLanguageUpdated = (languageCode) {
      onEvent("Language has changed ($languageCode)");
    };
    didomiListener.onLanguageUpdateFailed = (reason) {
      onEvent("Language has not changed: $reason");
    };

    DidomiSdk.addEventListener(didomiListener);
  }

  void onEvent(eventDescription) {
    uiCallback?.call(eventDescription);
  }
}
