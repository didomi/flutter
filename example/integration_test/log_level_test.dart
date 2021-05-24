import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/log_level.dart';
import 'package:didomi_sdk_example/test/sample_for_log_level_tests.dart' as logLevelApp;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final Finder setLogLevelBtnFinder = find.byKey(Key("setLogLevel"));

  group("Log Level", () {
    testWidgets("Reset SDK for bulk action", (WidgetTester tester) async {
      try {
        DidomiSdk.reset();
      } catch (ignored) {}
    });

    /// Log level change
    testWidgets("Set Log Level", (WidgetTester tester) async {
      // Start logLevelApp
      logLevelApp.main();
      await tester.pumpAndSettle();

      // Tap on log level button
      await tester.tap(setLogLevelBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("setLogLevel") &&
              widget.data?.contains("Native message: Level is error (${LogLevel.error.platformLevel}).") == true,
        ),
        findsOneWidget,
      );
    });
  });
}
