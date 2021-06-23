// Assert the text of the native message associated to a button.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import '../extensions/string_extension.dart';

/// Assert text in a Text widget whose key starts with "nativeResponse_" matches the expected value being passed.
Future<void> assertNativeMessage(String suffix, String expected) async {
  final actual = _extractTextFromWidget(suffix);
  assert(actual == expected, "Actual: $actual\nExpected: $expected");
}

/// Assert text in a Text widget whose key starts with "nativeResponse_" matches the expected regexp being passed.
Future<void> assertNativeMessageMatch(String suffix, String pattern) async {
  final actual = _extractTextFromWidget(suffix);
  assert(RegExp(pattern).hasMatch(actual), "Actual: $actual\nPattern: $pattern");
}

/// Assert text in a Text widget whose key starts with "nativeResponse_" starts with the expected value being passed.
Future<void> assertNativeMessageStartsWith(String suffix, String expected) async {
  final actual = _extractTextFromWidget(suffix);
  assert(actual.startsWith(expected), "Actual: $actual\nExpected: $expected");
}

/// Return text from Text widget whose key starts with "nativeResponse_" and ends with suffix.
String _extractTextFromWidget(String suffix) {
  final testKey = Key("nativeResponse_$suffix");
  final finder = find.byKey(testKey);
  expect(finder, findsOneWidget);
  final text = finder.evaluate().single.widget as Text;
  return text.data!.removeNewLines();
}
