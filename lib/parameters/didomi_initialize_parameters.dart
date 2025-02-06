/// Initialization parameters for Didomi SDK
class DidomiInitializeParameters {
  /// Your API key.
  String apiKey;

  /// Path to client specific config file in the app assets in JSON format (`didomi_config.json` by default).
  String? localConfigurationPath;

  /// URL to client specific remote config file in JSON format.
  String? remoteConfigurationUrl;

  /// Your provider ID (if any).
  String? providerId;

  /// If set to true, disable remote configuration (only local config file will be used).
  bool disableDidomiRemoteConfig = false;

  /// Language in which the consent UI should be displayed.
  /// By default, the consent UI is displayed in the language configured in the device settings, if language is available and enabled by your configuration.
  /// This property allows you to override the default setting and specify a language to display the UI in.
  /// String containing the language code e.g.: "es", "fr", etc.
  String? languageCode;

  /// ID of the notice configuration to load if you are not using app ID targeting (mobile devices).
  String? noticeId;

  /// ID of the notice configuration to load on TV devices if you are not using app ID targeting.
  /// If [androidTvEnabled] is true and SDK is launched on a TV device, this parameter will be used instead of [noticeId] to get configuration from console.
  String? androidTvNoticeId;

  /// If set to true, when launched on a AndroidTV device, the SDK will display TV notice:
  /// * Only Didomi remote config is allowed
  /// * Connected TV must be enabled for your organization, and [apiKey] / [tvNoticeId] must correspond to a TV notice in the console.
  /// If false or not set, the SDK will not be able to initialize on a TV device.
  bool androidTvEnabled = false;

  /// Override user country code when determining the privacy regulation to apply.
  /// Keep null to let the Didomi SDK determine the user country.
  String? countryCode;

  /// Override user region code when determining the privacy regulation to apply.
  /// Keep null to let the Didomi SDK determine the user region.
  /// Ignored if [countryCode] is not set.
  String? regionCode;

  /// If set to true, the SDK will only display the underage notice (false by default).
  bool isUnderage = false;

  DidomiInitializeParameters(
      {required this.apiKey,
      this.localConfigurationPath = null,
      this.remoteConfigurationUrl = null,
      this.providerId = null,
      this.disableDidomiRemoteConfig = false,
      this.languageCode = null,
      this.noticeId = null,
      this.androidTvNoticeId = null,
      this.androidTvEnabled = false,
      this.countryCode = null,
      this.regionCode = null,
      this.isUnderage = false});

  Map<String, dynamic> toJson() => {
        'apiKey': apiKey,
        'localConfigurationPath': localConfigurationPath,
        'remoteConfigurationUrl': remoteConfigurationUrl,
        'providerId': providerId,
        'disableDidomiRemoteConfig': disableDidomiRemoteConfig,
        'languageCode': languageCode,
        'noticeId': noticeId,
        'androidTvNoticeId': androidTvNoticeId,
        'androidTvEnabled': androidTvEnabled,
        'countryCode': countryCode,
        'regionCode': regionCode,
        'isUnderage': isUnderage,
      };
}
