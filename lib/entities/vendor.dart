// Class used to represent a vendor.
class Vendor implements Comparable<Vendor> {
  // Vendor ID.
  String? id;
  // IAB ID that the vendor should be mapped to (if vendor namespace is not **iab** and the vendor should be treated as an IAB vendor).
  String? iabId;
  // Name of the vendor.
  String? name;
  // URL to the privacy policy of the vendor.
  String? privacyPolicyUrl;
  // Namespace of the vendor (IAB, didomi or custom).
  String? namespace;
  // Namespaces of the vendor (IAB, didomi or custom) and their corresponding IDs.
  Map<String, String>? namespaces;
  // Purpose IDs that the vendor is operating under the consent legal basis.
  List<String>? purposeIds;
  // Purpose IDs that the vendor is operating under the legitimate interest legal basis.
  List<String>? legIntPurposeIds;
  // Set with IDs that represent features.
  List<String>? featureIds;
  // Set with IDs that represent flexible purposes. TCFv2 property.
  List<String> flexiblePurposeIds;
  // Set with IDs that represent Special Purposes. TCFv2 property.
  List<String> specialPurposeIds;
  // Set with IDs that represent Special Features. TCFv2 property.
  List<String> specialFeatureIds;
  // Cookie Max Age in Seconds.
  int? cookieMaxAgeSeconds;
  // If vendor uses other means of storage/access than cookies
  bool usesNonCookieAccess;
  // URL used to download Device Storage Disclosures (done post initialization).
  String? deviceStorageDisclosureUrl;

  Vendor(
      this.id,
      this.iabId,
      this.name,
      this.privacyPolicyUrl,
      this.namespace,
      this.namespaces,
      this.purposeIds,
      this.legIntPurposeIds,
      this.featureIds,
      this.flexiblePurposeIds,
      this.specialPurposeIds,
      this.specialFeatureIds,
      this.cookieMaxAgeSeconds,
      this.usesNonCookieAccess,
      this.deviceStorageDisclosureUrl
      );

  Vendor.fromJson(dynamic json)
      : id = json["id"],
        iabId = json["iabId"],
        name = json["name"],
        privacyPolicyUrl = json["privacyPolicyUrl"],
        namespace = json["namespace"],
        namespaces = json["namespaces"]?.cast<String, String>(),
        purposeIds = json["purposeIds"].cast<String>(),
        legIntPurposeIds = json["legIntPurposeIds"].cast<String>(),
        featureIds = json["featureIds"].cast<String>(),
        flexiblePurposeIds = json["flexiblePurposeIds"].cast<String>(),
        specialPurposeIds = json["specialPurposeIds"].cast<String>(),
        specialFeatureIds = json["specialFeatureIds"].cast<String>(),
        cookieMaxAgeSeconds = json["cookieMaxAgeSeconds"],
        usesNonCookieAccess = json["usesNonCookieAccess"],
        deviceStorageDisclosureUrl = json["deviceStorageDisclosureUrl"];

  @override
  int compareTo(Vendor other) => (id ?? "").compareTo(other.id ?? "");
}
