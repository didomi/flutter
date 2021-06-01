import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk/entities/vendor.dart';

// Utility class used to do computations related to vendors and purposes.
class EntitiesHelper {
  // Convert a list of dictionaries into a list of purposes.
  static List<Purpose> toPurposes(List<dynamic> rawList) => rawList.map((e) => Purpose.fromJson(e)).toList();

  // Convert a list of dictionaries into a list of vendors.
  static List<Vendor> toVendors(List<dynamic> rawList) => rawList.map((e) => Vendor.fromJson(e)).toList();
}