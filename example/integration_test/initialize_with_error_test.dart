import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_initialize_custom_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final isReadyBtnFinder = find.byKey(Key("isReady"));
  final onReadyBtnFinder = find.byKey(Key("onReady"));
  final initializeBtnFinder = find.byKey(Key("initialize"));
  final apiKeyFieldFinder = find.byKey(Key("apiKey"));
  final noticeIdFieldFinder = find.byKey(Key("noticeId"));

  String errorMessage = "";
  bool isError = false;
  bool isReady = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
    errorMessage = message;
  };
  listener.onReady = () {
    isReady = true;
  };

  DidomiSdk.addEventListener(listener);

  group("Initialize Error", () {
    testWidgets("Initialize with invalid parameters", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      // SDK is not ready at startup
      assertNativeMessage("isReady", resultFalseMessage);

      await tester.tap(onReadyBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("onReady", sdkNotReadyMessage);

      await tester.tap(apiKeyFieldFinder);
      await tester.pumpAndSettle();

      await tester.enterText(apiKeyFieldFinder, "");
      await tester.pumpAndSettle();

      await tester.tap(noticeIdFieldFinder);
      await tester.pumpAndSettle();

      await tester.enterText(noticeIdFieldFinder, "");
      await tester.pumpAndSettle();

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      // Wait for initialization error
      await Future.delayed(Duration(seconds: 4));

      // SDK is not ready
      await tester.tap(onReadyBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("isReady", resultFalseMessage);

      if (Platform.isAndroid) {
        assert(errorMessage == "Invalid Didomi API key");
      } else if (Platform.isIOS) {
        assert(errorMessage == "The initialization parameter API Key () is invalid.");
      }

      assert(isError == true);
      assert(isReady == false);
    });
  });
}
