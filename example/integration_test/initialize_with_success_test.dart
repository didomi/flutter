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
  final apiKeyFinder = find.byKey(Key("apiKey"));
  final noticeIDFinder = find.byKey(Key("noticeId"));
  final countryCodeFinder = find.byKey(Key("countryCode"));
  final regionCodeFinder = find.byKey(Key("regionCode"));
  final underageFinder = find.byKey(Key("isUnderage"));
  final disableRemoteConfigFinder = find.byKey(Key("disableRemoteConfig"));

  bool isError = false;
  bool isReady = false;
  String? regulation;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () async {
    isReady = true;
    regulation = (await DidomiSdk.currentUserStatus).regulation;
  };

  DidomiSdk.addEventListener(listener);

  // Reset expected variables used for assertions.
  void resetExpectedValues() {
    isError = false;
    isReady = false;
    regulation = null;
  }

  group("Initialize Success", () {

    // Run before each test.
    setUp(() {
      resetExpectedValues();
    });

    testWidgets("Initialize with default parameters", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      expect(isError, false);
      expect(isReady, false);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      // SDK is not ready at startup
      assertNativeMessage("isReady", resultFalseMessage);

      await tester.tap(onReadyBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("onReady", sdkNotReadyMessage);

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 4));

      assertNativeMessage("initialize", okMessage);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      // SDK is ready
      assertNativeMessage("isReady", resultTrueMessage);
      assertNativeMessage("onReady", sdkReadyMessage);

      expect(isError, false);
      expect(isReady, true);
      expect(regulation, "gdpr");
    });

    testWidgets("Initialize with custom parameters including country and region codes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      expect(isError, false);
      expect(isReady, false);
      expect(regulation, null);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      await tester.enterText(apiKeyFinder, "eea5ad63-29d4-4552-9dac-2edebe1fe518");
      await tester.enterText(noticeIDFinder, "bJERrrgk");
      await tester.enterText(countryCodeFinder, "US");
      await tester.enterText(regionCodeFinder, "CA");
      // This makes sure the on-screen keyboard is closed.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 4));

      assertNativeMessage("initialize", okMessage);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      expect(isError, false);
      expect(isReady, true);
      expect(regulation, "cpra");
    });

    testWidgets("Initialize with isUnderage true", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      expect(isError, false);
      expect(isReady, false);
      expect(regulation, null);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Check disable remote config
      await tester.tap(disableRemoteConfigFinder);
      await tester.pumpAndSettle();

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 4));

      assertNativeMessage("initialize", okMessage);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      expect(isError, false);
      expect(isReady, true);
      expect(regulation, "gdpr");
    });
  });
}
