class CurrentUserStatus {
  Map<String, PurposeStatus>? purposes;
  Map<String, VendorStatus>? vendors;
  String? userId;
  String? created;
  String? updated;
  String? consentString;
  String? additionalConsent;
  String? didomiDcs;
  String? regulation;

  CurrentUserStatus({this.purposes, this.vendors});

  CurrentUserStatus.fromJson(dynamic json)
      : purposes = (json["purposes"] as Map).map((key, value) => MapEntry(key, PurposeStatus.fromJson(value))),
        vendors = (json["vendors"] as Map).map((key, value) => MapEntry(key, VendorStatus.fromJson(value))),
        userId = json["user_id"],
        created = json["created"],
        updated = json["updated"],
        consentString = json["consent_string"],
        additionalConsent = json["addtl_consent"],
        didomiDcs = json["didomi_dcs"],
        regulation = json["regulation"];
}

class PurposeStatus {
  String id;
  bool enabled;

  PurposeStatus({required this.id, this.enabled = false});

  PurposeStatus.fromJson(dynamic json)
      : id = json["id"],
        enabled = json["enabled"] as bool;
}

class VendorStatus {
  String id;
  bool enabled;

  VendorStatus({required this.id, this.enabled = false});

  VendorStatus.fromJson(dynamic json)
      : id = json["id"],
        enabled = json["enabled"] as bool;
}
