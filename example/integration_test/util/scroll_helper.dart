// Tap on a button that will scroll the list to the last element.
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> scrollDown(WidgetTester tester, Key key) async {
  await tester.drag(find.byKey(Key('components_list')), const Offset(0.0, -300));
  await tester.pump();
}