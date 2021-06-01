import 'dart:io';

import 'package:didomi_sdk_example/test/sample_for_log_level_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final Finder setLogLevelBtnFinder = find.byKey(Key("setLogLevel"));

  group("Log Level", () {
    /// Log level change
    testWidgets("Set Log Level", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Tap on log level button
      await tester.tap(setLogLevelBtnFinder);
      await tester.pumpAndSettle();

      String message = "";
      if (Platform.isAndroid) {
        message = "Native message: Level is error (6).";
      } else if (Platform.isIOS) {
        message = "Native message: Level is error (17).";
      }

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setLogLevel") &&
              widget.data?.contains(message) == true,
        ),
        findsOneWidget,
      );
    });
  });
}
