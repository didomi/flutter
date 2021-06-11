// Tap on a button that will scroll the list to the last element.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

// Scrolling in Flutter is challenging. Since elements off the screen might be
// easily accessible.
// As a way to get around this issue, we created some methods that allow
// us to scroll up and down.

// Drag gesture downwards within a scrollable item.
Future<void> scrollDown(WidgetTester tester, Key key) async {
  await tester.drag(find.byKey(key), const Offset(0.0, -300));
  await tester.pump();
}