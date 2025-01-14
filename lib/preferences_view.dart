/// Possible opened pages when calling showPreferences
enum PreferencesView {
  /// Main preferences screen
  purposes,

  /// Sensitive Personal Information preferences screen
  @Deprecated("SPI purposes are now displayed in Preferences screen, use PreferencesView.purposes instead.")
  sensitivePersonalInformation,

  /// Vendors preferences screen
  vendors
}

/// Extension to get the name of the enum
extension PreferencesViewExtension on PreferencesView {
  String get name {
    if (this == PreferencesView.vendors) {
      return "vendors";
    }
    return "purposes";
  }
}
