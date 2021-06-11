// Assert the text of the native message associated to a button.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import '../extensions/string_extension.dart';

// Assert expected text in a Text widget whose key starts with "nativeResponse_".
Future<void> assertNativeMessage(String suffix, String expected) async {
  final testKey = Key("nativeResponse_$suffix");
  final finder = find.byKey(testKey);
  final text = finder.evaluate().single.widget as Text;
  final actual = text.data!.removeNewLines();
  assert(actual == expected, "Actual: $actual\nExpected: $expected");
}
