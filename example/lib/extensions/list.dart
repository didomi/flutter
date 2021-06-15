import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk/entities/vendor.dart';

const _separator = ", ";

/// List extension.
extension ListPrettyPrint on List<String> {
  /// Extension method used to return readable content.
  String pretty() => this.join(_separator);
}

extension VendorListPrettyPrint on List<Vendor> {
  /// Extension method used to return readable Vendor content.
  String pretty() => this.map((vendor) => vendor.name).join(_separator);
}

extension PurposeListPrettyPrint on List<Purpose> {
  /// Extension method used to return readable Purpose content.
  String pretty() => this.map((purpose) => purpose.name).join(_separator);
}
