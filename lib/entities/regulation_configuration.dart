/// Class used to represent the regulation configuration applicable for the user (identity and version).
///
/// **Beta**: this API is in beta and may change in future releases.
class RegulationConfiguration {
  // Regulation configuration ID.
  String id;
  // Regulation configuration version ID.
  String? versionId;
  // Regulation configuration numerical ID.
  int? numericalId;
  // Regulation name from the configuration (for example "gdpr").
  String regulationName;
  // Key under which the consent token is saved.
  String tokenStorageName;
  // Whether the regulation configuration belongs to the "mixed" group.
  bool mixed;

  RegulationConfiguration(this.id, this.versionId, this.numericalId, this.regulationName, this.tokenStorageName, this.mixed);

  RegulationConfiguration.fromJson(dynamic json)
      : id = json["id"],
        versionId = json["versionId"],
        numericalId = (json["numericalId"] as num?)?.toInt(),
        regulationName = json["regulationName"],
        tokenStorageName = json["tokenStorageName"],
        mixed = json["mixed"] as bool;
}
