// Tap on a button that will scroll the list to the last element.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

/// Scrolling in Flutter is challenging. Since elements off the screen might be
/// easily accessible.
/// As a way to get around this issue, we created some methods that allow
/// us to scroll up and down.

/// Drag gesture downwards within a scrollable item.
Future<void> scrollDown(WidgetTester tester, Key key, {int offsetY = 300}) async {
  await tester.drag(find.byKey(key),  Offset(0.0, -offsetY.toDouble()));
  await tester.pumpAndSettle();
}
/// Drag gesture upwards within a scrollable item.
Future<void> scrollUp(WidgetTester tester, Key key, {int offsetY = 300}) async {
  await tester.drag(find.byKey(key),  Offset(0.0, -offsetY.toDouble()));
  await tester.pumpAndSettle();
}
