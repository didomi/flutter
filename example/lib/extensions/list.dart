import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk/entities/vendor.dart';

const _separator = ", ";

/// List extension.
extension ListPrettyPrint on List<String> {
  /// Extension method used to return readable content.
  String joinToString({String separator = _separator}) => this.join(separator);
}

extension VendorListPrettyPrint on List<Vendor> {
  /// Extension method used to return readable Vendor content.
  String joinToString({String separator = _separator}) => this.map((vendor) => vendor.name).join(separator);
}

extension PurposeListPrettyPrint on List<Purpose> {
  /// Extension method used to return readable Purpose content.
  String joinToString({String separator = _separator}) => this.map((purpose) => purpose.name).join(separator);
}
