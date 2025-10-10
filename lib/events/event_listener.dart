import 'package:didomi_sdk/events/sync_ready_event.dart';

import 'integration_error_event.dart';

/// Listener to events sent by the Didomi SDK
class EventListener {
  /*
   * SDK lifecycle events
   */

  /// SDK is ready
  dynamic Function() onReady = () {};

  /// SDK encountered an error
  dynamic Function(String message) onError = (message) {};

  /*
   * Notice events
   */

  /// Notice was displayed or should be displayed
  dynamic Function() onShowNotice = () {};

  /// Notice was hidden
  dynamic Function() onHideNotice = () {};

  /// Preferences screen was displayed
  dynamic Function() onShowPreferences = () {};

  /// Preferences screen was hidden
  dynamic Function() onHidePreferences = () {};

  /// Agree to all was clicked from the notice
  dynamic Function() onNoticeClickAgree = () {};

  /// Disagree to all was clicked from the notice
  dynamic Function() onNoticeClickDisagree = () {};

  /// Vendors screen was opened from the notice
  dynamic Function() onNoticeClickViewVendors = () {};

  /// SPI screen was opened from the notice
  @Deprecated("SPI purposes are now displayed in preferences screen, use onNoticeClickMoreInfo instead.")
  dynamic Function() onNoticeClickViewSPIPurposes = () {};

  /// Preferences screen was opened from the notice
  dynamic Function() onNoticeClickMoreInfo = () {};

  /// Privacy policy was opened from the notice (TV)
  dynamic Function() onNoticeClickPrivacyPolicy = () {};

  /*
   * Preferences screen events
   */

  /// Agree to all was clicked from the preferences screen
  dynamic Function() onPreferencesClickAgreeToAll = () {};

  /// Disagree to all was clicked from the preferences screen
  dynamic Function() onPreferencesClickDisagreeToAll = () {};

  /// User switched a purpose status to Agree
  dynamic Function(String purposeId) onPreferencesClickPurposeAgree = (purposeId) {};

  /// User switched a purpose status to Disagree
  dynamic Function(String purposeId) onPreferencesClickPurposeDisagree = (purposeId) {};

  /// User switched a category status to Agree
  dynamic Function(String categoryId) onPreferencesClickCategoryAgree = (categoryId) {};

  /// User switched a category status to Disagree
  dynamic Function(String categoryId) onPreferencesClickCategoryDisagree = (categoryId) {};

  /// Vendors screen was opened from preferences screen
  dynamic Function() onPreferencesClickViewVendors = () {};

  /// SPI screen was opened from preferences screen
  @Deprecated("SPI purposes are now displayed in preferences screen.")
  dynamic Function() onPreferencesClickViewSPIPurposes = () {};

  /// Save button was clicked from preferences screen
  dynamic Function() onPreferencesClickSaveChoices = () {};

  /// Purposes bulk action was switched to Agree
  dynamic Function() onPreferencesClickAgreeToAllPurposes = () {};

  /// Purposes bulk action was switched to Disagree
  dynamic Function() onPreferencesClickDisagreeToAllPurposes = () {};

  /// Purposes bulk action was switched to neutral
  dynamic Function() onPreferencesClickResetAllPurposes = () {};

  /*
   * Vendors screen events
   */

  /// User switched a vendor status to Agree
  dynamic Function(String vendorId) onPreferencesClickVendorAgree = (vendorId) {};

  /// User switched a vendor status to Disagree
  dynamic Function(String vendorId) onPreferencesClickVendorDisagree = (vendorId) {};

  /// Save button was clicked from vendors screen
  dynamic Function() onPreferencesClickVendorSaveChoices = () {};

  /// Purposes tab was opened on preferences screen (TV)
  dynamic Function() onPreferencesClickViewPurposes = () {};

  /// Vendors bulk action was switched to Agree
  dynamic Function() onPreferencesClickAgreeToAllVendors = () {};

  /// Vendors bulk action was switched to Disagree
  dynamic Function() onPreferencesClickDisagreeToAllVendors = () {};

  /*
   * SPI screen events
   */

  /// User switched a SPI purpose status to Agree
  @Deprecated("SPI purposes are now treated as other purposes, use onPreferencesClickPurposeAgree instead.")
  dynamic Function(String purposeId) onPreferencesClickSPIPurposeAgree = (purposeId) {};

  /// User switched a SPI purpose status to Disagree
  @Deprecated("SPI purposes are now treated as other purposes, use onPreferencesClickPurposeDisagree instead.")
  dynamic Function(String purposeId) onPreferencesClickSPIPurposeDisagree = (purposeId) {};

  /// User switched a SPI category status to Agree
  @Deprecated("SPI purposes are now treated as other purposes, use onPreferencesClickCategoryAgree instead.")
  dynamic Function(String categoryId) onPreferencesClickSPICategoryAgree = (categoryId) {};

  /// User switched a SPI category status to Disagree
  @Deprecated("SPI purposes are now treated as other purposes, use onPreferencesClickCategoryDisagree instead.")
  dynamic Function(String categoryId) onPreferencesClickSPICategoryDisagree = (categoryId) {};

  /// Save button was clicked from SPI screen
  @Deprecated("SPI purposes are now displayed in preferences screen, use onPreferencesClickSaveChoices instead.")
  dynamic Function() onPreferencesClickSPIPurposeSaveChoices = () {};

  /*
   * Consent events
   */

  /// User consent was updated
  dynamic Function() onConsentChanged = () {};

  /// User consent synchronization is ready
  dynamic Function(SyncReadyEvent event) onSyncReady = (event) {};

  /// User consent synchronization was done
  @Deprecated("Use 'onSyncReady' instead")
  dynamic Function(String organizationUserId) onSyncDone = (organizationUserId) {};

  /// User consent synchronization failed
  dynamic Function(String error) onSyncError = (error) {};

  /*
   * Language change events
   */

  /// The language update is complete
  dynamic Function(String languageCode) onLanguageUpdated = (languageCode) {};

  /// The language update is complete
  dynamic Function(String reason) onLanguageUpdateFailed = (reason) {};

  /*
   * DCS signature events
   */

  /// DCS signature generation encountered an error
  dynamic Function() onDcsSignatureError = () {};

  /// DCS signature is ready
  dynamic Function() onDcsSignatureReady = () {};

  /*
   * GCM - External SDKs integration events
   */

  /// Integration with an external SDK encountered an error
  dynamic Function(IntegrationErrorEvent event) onIntegrationError = (event) {};
}
