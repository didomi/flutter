
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
  /// Notice was displayed
  dynamic Function() onShowNotice = () {};
  /// Notice was hidden
  dynamic Function() onHideNotice = () {};
  /// Agree to all was clicked from the notice
  dynamic Function() onNoticeClickAgree = () {};
  /// Disagree to all was clicked from the notice
  dynamic Function() onNoticeClickDisagree = () {};
  /// Vendors screen was opened from the notice
  dynamic Function() onNoticeClickViewVendors = () {};
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
   * Consent events
   */
  /// User consent was updated
  dynamic Function() onConsentChanged = () {};
  /// User consent synchronization was done
  dynamic Function(String organizationUserId) onSyncDone = (organizationUserId) {};

}
