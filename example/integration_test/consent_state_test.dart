import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_consent_state_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final resetBtnFinder = find.byKey(Key("reset"));
  final checkConsentStateBtnFinder = find.byKey(Key("checkConsentState"));

  bool isError = false;
  bool isReady = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };

  DidomiSdk.addEventListener(listener);

  group("Consent State", () {
    testWidgets("Check Consent State without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(checkConsentStateBtnFinder);
      await tester.pumpAndSettle();

      if (Platform.isAndroid) {
        assertNativeMessage("checkConsentState", notReadyMessage);
        assert(isError == false);
      } else if (Platform.isIOS) {
        assertNativeMessage(
            "checkConsentState",
            'Native message: '
                '- Is user consent required? false'
                '- Should consent be collected? false'
                '- Is status partial? consent => false, LI => false'
                '- Is user status partial? false');
        assert(isError == true);

        // Reset error only for iOS
        isError = false;
      }

      assert(isReady == false);
    });

    testWidgets("Check Consent State with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(checkConsentStateBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage(
          "checkConsentState",
          'Native message: '
              '- Is user consent required? true'
              '- Should consent be collected? true'
              '- Is status partial? consent => true, LI => true'
              '- Is user status partial? true');
    });

    testWidgets("Check Consent State by agreeing then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      // Agree
      await tester.tap(agreeToAllBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("setUserAgreeToAll", "Native message: Consent updated: true.");

      await tester.tap(checkConsentStateBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage(
          "checkConsentState",
          'Native message: '
              '- Is user consent required? true'
              '- Should consent be collected? false'
              '- Is status partial? consent => false, LI => false'
              '- Is user status partial? false');

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(checkConsentStateBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage(
          "checkConsentState",
          'Native message: '
              '- Is user consent required? true'
              '- Should consent be collected? true'
              '- Is status partial? consent => true, LI => true'
              '- Is user status partial? true');
    });

    testWidgets("Check Consent State by disagreeing then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      // Disagree
      await tester.tap(disagreeToAllBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("setUserDisagreeToAll", "Native message: Consent updated: true.");

      await tester.tap(checkConsentStateBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage(
          "checkConsentState",
          'Native message: '
              '- Is user consent required? true'
              '- Should consent be collected? false'
              '- Is status partial? consent => false, LI => false'
              '- Is user status partial? false');

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(checkConsentStateBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage(
          "checkConsentState",
          'Native message: '
              '- Is user consent required? true'
              '- Should consent be collected? true'
              '- Is status partial? consent => true, LI => true'
              '- Is user status partial? true');
    });
  });
}
