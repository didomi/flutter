
/// Listener to events sent by the Didomi SDK
class EventListener {
  /// SDK is ready
  dynamic Function() onReady = () {};
  /// SDK encountered an error
  dynamic Function(String message) onError = (message) {};
  /// Notice was displayed
  dynamic Function() onShowNotice = () {};
  /// Notice was hidden
  dynamic Function() onHideNotice = () {};
  dynamic Function() onNoticeClickAgree = () {};
  dynamic Function() onNoticeClickDisagree = () {};
  dynamic Function() onNoticeClickViewVendors = () {};
  dynamic Function() onNoticeClickMoreInfo = () {};
  dynamic Function() onNoticeClickPrivacyPolicy = () {};
  dynamic Function() onPreferencesClickAgreeToAll = () {};
  dynamic Function() onPreferencesClickDisagreeToAll = () {};
  dynamic Function(String purposeId) onPreferencesClickPurposeAgree = (purposeId) {};
  dynamic Function(String purposeId) onPreferencesClickPurposeDisagree = (purposeId) {};
  dynamic Function(String categoryId) onPreferencesClickCategoryAgree = (categoryId) {};
  dynamic Function(String categoryId) onPreferencesClickCategoryDisagree = (categoryId) {};
  dynamic Function() onPreferencesClickViewVendors = () {};
  dynamic Function() onPreferencesClickSaveChoices = () {};
  dynamic Function(String vendorId) onPreferencesClickVendorAgree = (vendorId) {};
  dynamic Function(String vendorId) onPreferencesClickVendorDisagree = (vendorId) {};
  dynamic Function() onPreferencesClickVendorSaveChoices = () {};
  dynamic Function() onPreferencesClickViewPurposes = () {};
  dynamic Function() onConsentChanged = () {};
  dynamic Function() onPreferencesClickAgreeToAllPurposes = () {};
  dynamic Function() onPreferencesClickDisagreeToAllPurposes = () {};
  dynamic Function() onPreferencesClickResetAllPurposes = () {};
  dynamic Function() onPreferencesClickAgreeToAllVendors = () {};
  dynamic Function() onPreferencesClickDisagreeToAllVendors = () {};
  dynamic Function(String organizationUserId) onSyncDone = (organizationUserId) {};

}