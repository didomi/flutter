import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk/entities/vendor.dart';

/// List extension.
extension ListPrettyPrint on List<String> {
  /// Extension method used to print content.
  String pretty() => this.join(", ");
}

extension VendorListPrettyPrint on List<Vendor> {
  /// Extension method used to print Vendor content.
  String pretty() => this.map((vendor) => vendor.name).join(", ");
}

extension PurposeListPrettyPrint on List<Purpose> {
  /// Extension method used to print Purpose content.
  String pretty() => this.map((purpose) => purpose.name).join(", ");
}
