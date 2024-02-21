// Class used to represent a vendor.
class VendorUrl {
  // URL language localization
  String? langId;
  // Privacy disclaimer URL.
  String? privacy;
  // Legitimate interest disclaimer URL.
  String? legIntClaim;

  VendorUrl(
      this.langId,
      this.privacy,
      this.legIntClaim);

  VendorUrl.fromJson(dynamic json)
      : langId = json["langId"],
        privacy = json["privacy"],
        legIntClaim = json["legIntClaim"];
}
