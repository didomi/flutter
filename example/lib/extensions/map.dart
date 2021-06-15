import 'dart:collection';

/// Map extension.
extension MapSorting on Map {
  /// Extension method used to sort map by keys.
  SplayTreeMap sortByKey() => SplayTreeMap<String, dynamic>.from(this, (key1, key2) => this[key1]!.compareTo(this[key2]!));
}
