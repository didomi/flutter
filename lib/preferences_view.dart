/// Possible opened pages when calling showPreferences
enum PreferencesView {
  /// Main preferences screen
  purposes,

  /// Sensitive Personal Information preferences screen
  sensitivePersonalInformation,

  /// Vendors preferences screen
  vendors
}

/// Extension to get the name of the enum
extension PreferencesViewExtension on PreferencesView {
  String get name {
    switch (this) {
      case PreferencesView.sensitivePersonalInformation:
        return "sensitive-personal-information";
      case PreferencesView.vendors:
        return "vendors";
      default:
        // purposes is the default value
        return "purposes";
    }
  }
}
