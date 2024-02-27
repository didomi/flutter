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

  Vendor.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        policyUrl = json["policyUrl"],
        namespaces = json["namespaces"] != null ? Namespaces.fromJson(json["namespaces"]) : null,
        purposeIds = json["purposeIds"].cast<String>(),
        legIntPurposeIds = json["legIntPurposeIds"].cast<String>(),
        featureIds = json["featureIds"].cast<String>(),
        flexiblePurposeIds = json["flexiblePurposeIds"].cast<String>(),
        specialPurposeIds = json["specialPurposeIds"].cast<String>(),
        specialFeatureIds = json["specialFeatureIds"].cast<String>(),
        urls = (json["urls"] as List?)?.map((json) => Url.fromJson(json)).toList();

  @override
  int compareTo(Vendor other) => (id ?? "").compareTo(other.id ?? "");
}

class Namespaces {
  String? iab2;
  int? num;

  Namespaces(this.iab2, this.num);

  Namespaces.fromJson(dynamic json)
      : iab2 = json["iab2"],
        num = json["num"];
}

class Url {
  String langId;
  String? privacy;
  String? legIntClaim;

  Url(this.langId, this.privacy, this.legIntClaim);

  Url.fromJson(dynamic json)
      : langId = json["langId"],
        privacy = json["privacy"],
        legIntClaim = json["legIntClaim"];
}
