import 'package:flutter_test/flutter_test.dart';

class InitializeHelper {
  static Future initialize(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 2));
  }
}
