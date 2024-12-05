import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_setup_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final setLogLevelBtnFinder = find.byKey(Key("setLogLevel"));
  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final setupUIBtnFinder = find.byKey(Key("setupUI"));

  bool isError = false;
  bool isReady = false;
  bool noticeWasShown = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };
  listener.onShowNotice = () {
    noticeWasShown = true;
  };

  DidomiSdk.addEventListener(listener);

  group("Setup UI", () {
    testWidgets("Set Log Level", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Tap on log level button
      await tester.tap(setLogLevelBtnFinder);
      await tester.pumpAndSettle();

      String expected = "";
      if (Platform.isAndroid) {
        expected = "Native message: Level is error (6).";
      } else if (Platform.isIOS) {
        expected = "Native message: Level is error (17).";
      }
      assertNativeMessage("setLogLevel", expected);
    });

    testWidgets("Setup UI and initialize after", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(setupUIBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      assertNativeMessage("setupUI", okMessage);

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 5));

      assert(isError == false);
      assert(isReady == true);
      assert(noticeWasShown == true);
    });
  });
}
