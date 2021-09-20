import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk/entities/vendor.dart';

import 'user_status.dart';

/// Utility class used to do computations related to vendors and purposes.
class EntitiesHelper {
  /// Convert a list of dictionaries into a list of purposes.
  static List<Purpose> toPurposes(List<dynamic> rawList) => rawList.map((e) => Purpose.fromJson(e)).toList();

  /// Convert a list of dictionaries into a list of vendors.
  static List<Vendor> toVendors(List<dynamic> rawList) => rawList.map((e) => Vendor.fromJson(e)).toList();

  /// Convert json to status Ids, or null
  static Ids? toIds(dynamic json) => json != null ? Ids.fromJson(json) : null;

  /// Convert json to purposes status info, or null
  static Purposes? toPurposesStatus(dynamic json) => json != null ? Purposes.fromJson(json) : null;

  /// Convert json to vendors status info, or null
  static Vendors? toVendorsStatus(dynamic json) => json != null ? Vendors.fromJson(json) : null;

}
