import 'package:didomi_sdk/entities/entities_helper.dart';

/// User Status
/// Type used to represent the user status.
/// This contains all the choices made by the user on the Didomi SDK and other related information
/// such as consent string and dates when the status was created or updated.
/// Essential purposes are considered as enabled in computed/global properties.
class UserStatus {
  /// Property that contains the user status associated to purposes.
  Purposes? purposes;
  /// Property that contains the user status associated to vendors.
  Vendors? vendors;
  /// Didomi user id
  String? userId;
  /// User choices creation date
  String? created;
  /// User choices update date
  String? updated;
  /// TCF consent as string
  String? consentString;
  /// Additional consent
  String? additionalConsent;

  UserStatus.fromJson(dynamic json)
    : purposes = EntitiesHelper.toPurposesStatus(json["purposes"]),
      vendors = EntitiesHelper.toVendorsStatus(json["vendors"]),
      userId = json["user_id"],
      created = json["created"],
      updated = json["updated"],
      consentString = json["consent_string"],
      additionalConsent = json["addtl_consent"];
}

/// User status for purposes
class Purposes {
  /// Computed sets/lists of enabled and disabled IDs of purposes that have been chosen by the user regarding the consent or legitimate interest Legal Basis.
  /// Purposes considered as essential will be part of the enabled IDs.
  Ids? global;

  /// Enabled and disabled IDs of purposes that have been explicitly chosen by the user regarding the consent Legal Basis.
  Ids? consent;

  /// Enabled and disabled IDs of purposes that have been explicitly chosen by the user regarding the legitimate interest Legal Basis.
  Ids? legitimateInterest;

  /// IDs of purposes that are considered essential.
  List<String>? essential;

  Purposes.fromJson(dynamic json)
      : global = EntitiesHelper.toIds(json["global"]),
        consent = EntitiesHelper.toIds(json["consent"]),
        legitimateInterest = EntitiesHelper.toIds(json["legitimate_interest"]),
        essential = json["essential"]?.cast<String>();
}

/// User status for vendors
class Vendors {
  /// Computed sets/lists of enabled and disabled IDs of vendors that have been chosen by the user regarding the consent or legitimate interest Legal Basis.
  /// This takes into account the consent and legitimate interest required purposes linked to vendors.
  /// When computing this property, essential purposes will be considered as enabled.
  Ids? global;

  /// Computed sets/lists of enabled and disabled IDs of vendors that have been chosen by the user regarding the consent Legal Basis.
  /// This takes into account the consent required purposes linked to vendors.
  /// When computing this property, essential purposes will be considered as enabled.
  Ids? globalConsent;

  /// Computed sets/lists of enabled and disabled IDs of vendors that have been chosen by the user regarding the legitimate interest Legal Basis.
  /// This takes into account the legitimate interest required purposes linked to vendors.
  /// When computing this property, essential purposes will be considered as enabled.
  Ids? globalLegitimateInterest;

  /// Enabled and disabled IDs of vendors that have been explicitly chosen by the user regarding the consent Legal Basis.
  Ids? consent;

  /// Enabled and disabled IDs of vendors that have been explicitly chosen by the user regarding the legitimate interest Legal Basis.
  Ids? legitimateInterest;

  Vendors.fromJson(dynamic json)
      : global = EntitiesHelper.toIds(json["global"]),
        globalConsent = EntitiesHelper.toIds(json["global_consent"]),
        globalLegitimateInterest = EntitiesHelper.toIds(json["global_li"]),
        consent = EntitiesHelper.toIds(json["consent"]),
        legitimateInterest = EntitiesHelper.toIds(json["legitimate_interest"]);
}

/// User ids list for purposes and vendors
class Ids {
  /// List of disabled ids
  List<String>? disabled;
  /// List of enabled ids
  List<String>? enabled;

  Ids.fromJson(dynamic json)
      : disabled = json["disabled"]?.cast<String>(),
        enabled = json["enabled"]?.cast<String>();
}
