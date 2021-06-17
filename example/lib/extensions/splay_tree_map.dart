import 'dart:collection';

/// SplayTreeMap extension.
extension SplayTreeMapPrettyPrint on SplayTreeMap {
  /// Extension method used to print content.
  String joinToString(String prefix) {
    StringBuffer sb = StringBuffer(prefix);
    this.entries.forEach((element) {
      sb.writeln("${element.key} =>");
      sb.writeln(element.value);
    });
    return sb.toString();
  }
}
