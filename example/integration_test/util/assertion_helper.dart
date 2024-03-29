import 'package:didomi_sdk/entities/current_user_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../extensions/string_extension.dart';

/// Assert text in a Text widget whose key starts with "nativeResponse_" matches the expected value being passed.
Future<void> assertNativeMessage(String suffix, String expected) async {
  final actual = _extractTextFromWidget(suffix);
  assert(actual == expected, "Actual: $actual\nExpected: $expected");
}

/// Assert text in a Text widget whose key starts with "nativeResponse_" contains the expected value being passed.
Future<void> assertNativeMessageContains(String suffix, List<String> expectedList) async {
  final actual = _extractTextFromWidget(suffix);
  var result = true;
  for (String expected in expectedList) {
    result = result && actual.contains(expected);
  }
  assert(result, "Actual: $actual\nExpected list: ${expectedList.join(", ")}");
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

void assertTextNotEmpty(String? text) {
  assert((text ?? "").isNotEmpty, "$text should have a value");
}

void assertListNotEmpty(List? elements) {
  assert(elements != null && elements.length > 0);
}

void assertListEmpty(List? elements) {
  assert(elements != null && elements.length == 0, "List should be empty but was: ${elements?.join("-")}");
}

void assertListContains(List<String>? elements, String contained) {
  assert(elements != null && elements.contains(contained), "List should contain $contained, but was: ${elements?.join("-")}");
}

void assertListDoesNotContain(List<String>? elements, String excluded) {
  assert(elements != null && !elements.contains(excluded), "List should not contain $excluded, but was: ${elements?.join("-")}");
}

void assertMatchesUuidPattern(String? text, {String? message}) {
  RegExp exp = RegExp(r"\S{8}-\S{4}-\S{4}-\S{4}-\S{12}");
  assert(exp.hasMatch(text ?? ""), "$text should be an UUID");
}

void assertMatchesDatePattern(String? text, {String? message}) {
  RegExp exp = RegExp(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:.\d{3})?Z");
  assert(exp.hasMatch(text ?? ""), "$text should be a date");
}

void assertPurposeStatusMapContains(Map? map, PurposeStatus? purposeStatus) {
  expect(map?[purposeStatus?.id].id, purposeStatus?.id, reason: "Purpose status map should contain ${purposeStatus?.id}");
  expect(map?[purposeStatus?.id].enabled, purposeStatus?.enabled, reason: "Purpose status item ${purposeStatus?.id} is expected to be ${purposeStatus?.enabled}");
}

void assertVendorStatusMapContains(Map? map, VendorStatus? vendorStatus) {
  expect(map?[vendorStatus?.id].id, vendorStatus?.id, reason: "Vendor status map should contain ${vendorStatus?.id}");
  expect(map?[vendorStatus?.id].enabled, vendorStatus?.enabled, reason: "Vendor status item ${vendorStatus?.id} is expected to be ${vendorStatus?.enabled}");
}
