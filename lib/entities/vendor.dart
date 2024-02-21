// Class used to represent a vendor.
class Vendor implements Comparable<Vendor> {
  // Vendor ID.
  String? id;
  // Name of the vendor.
  String? name;
  // URL to the privacy policy of the vendor.
  String? policyUrl;
  // Namespaces of the vendor (IAB, didomi or custom) and their corresponding IDs.
  Namespaces? namespaces;
  // Purpose IDs that the vendor is operating under the consent legal basis.
  List<String> purposeIds;
  // Purpose IDs that the vendor is operating under the legitimate interest legal basis.
  List<String> legIntPurposeIds;
  // Set with IDs that represent features.
  List<String> featureIds;
  // Set with IDs that represent flexible purposes. Introduced in IAB TCF v2.
  List<String> flexiblePurposeIds;
  // Set with IDs that represent Special Purposes. Introduced in IAB TCF v2.
  List<String> specialPurposeIds;
  // Set with IDs that represent Special Features. Introduced in IAB TCF v2.
  List<String> specialFeatureIds;
  // Privacy policy and LI disclaimer urls. Introduced in IAB TCF v2.2.
  List<Url>? urls;

  Vendor(
      this.id,
      this.name,
      this.namespaces,
      this.purposeIds,
      this.legIntPurposeIds,
      this.featureIds,
      this.flexiblePurposeIds,
      this.specialPurposeIds,
      this.specialFeatureIds,
      this.urls);

  // When parsing a Vendor, we need to consider that some properties are parsed differently on Android and iOS,
  // mainly because TCFv1 used properties such as purposeIds and TCFv2 uses properties such as purposes.
  Vendor.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        policyUrl = json["policyUrl"],
        namespaces = json["namespaces"]?.cast<Namespaces>(),
        purposeIds = (json["purposeIds"] ?? json["purposes"]).cast<String>(),
        legIntPurposeIds = (json["legIntPurposeIds"] ?? json["legIntPurposes"]).cast<String>(),
        featureIds = (json["featureIds"] ?? json["features"]).cast<String>(),
        flexiblePurposeIds = (json["flexiblePurposeIds"] ?? json["flexiblePurposes"]).cast<String>(),
        specialPurposeIds = (json["specialPurposeIds"] ?? json["specialPurposes"]).cast<String>(),
        specialFeatureIds = (json["specialFeatureIds"] ?? json["specialFeatures"]).cast<String>(),
        urls = json["urls"]?.cast<Url>();

  @override
  int compareTo(Vendor other) => (id ?? "").compareTo(other.id ?? "");
}

class Namespaces {
  String iab2;
  int num;

  Namespaces(this.iab2, this.num);
}

class Url {
  String langId;
  String privacy;
  String legIntClaim;

  Url(this.langId, this.privacy, this.legIntClaim);
}
