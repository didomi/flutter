enum ConsentStatus { disable, enable, unknown }

extension ConsentStatusExtension on ConsentStatus {
  /// Get String value for consent status
  String get string {
    switch (this) {
      case ConsentStatus.disable:
        return "Disabled";
      case ConsentStatus.enable:
        return "Enabled";
      case ConsentStatus.unknown:
      default:
        return "Unknown";
    }
  }

  /// Is consent status is disabled
  bool get isDisabled => this == ConsentStatus.disable;

  /// Is consent status is enabled
  bool get isEnabled => this == ConsentStatus.enable;

  /// Is consent status is unknown
  bool get isUnknown => this == ConsentStatus.unknown;
}
