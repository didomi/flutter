import 'dart:collection';

/// Map extension.
extension MapSorting on Map {
  /// Extension method used to sort map by keys.
  SplayTreeMap sortByKey() => SplayTreeMap<String, dynamic>.from(this, (a, b) => this[a]!.compareTo(this[b]!));
}
