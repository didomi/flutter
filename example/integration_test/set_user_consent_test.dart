import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_set_user_consent_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String consentUpdatedMessage = "Native message: Consent updated: true.";
  const String consentNotUpdatedMessage = "Native message: Consent updated: false.";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final resetBtnFinder = find.byKey(Key("reset"));
  final userStatusBtnFinder = find.byKey(Key("setUserStatus"));
  final userStatusGloballyBtnFinder = find.byKey(Key("setUserStatusGlobally"));

  bool isError = false;
  bool isReady = false;
  bool consentChanged = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };
  listener.onConsentChanged = () {
    consentChanged = true;
  };

  DidomiSdk.addEventListener(listener);

  group("User Consent", () {
    /*
     * Without initialization
     */

    testWidgets("Click agree to all without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Tap on Agree All button
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserAgreeToAll", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Click disagree to all without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Tap on Disagree All button
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserDisagreeToAll", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Click user status without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Tap on User status button
      await tester.tap(userStatusBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserStatus", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Click global user status without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Tap on User status button
      await tester.tap(userStatusGloballyBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserStatusGlobally", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    /*
     * With initialization
     */

    testWidgets("Click agree to all with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      // First click returns true
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserAgreeToAll", consentUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);

      // Second click returns false
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserAgreeToAll", consentNotUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click agree to all after reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // First click returns false (already clicked before)
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserAgreeToAll", consentNotUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // Click after reset returns true
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserAgreeToAll", consentUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click disagree to all with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // First click returns true
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserDisagreeToAll", consentUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);

      // Second click returns false
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserDisagreeToAll", consentNotUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click disagree to all after reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // First click returns false (already clicked before)
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserDisagreeToAll", consentNotUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // Click after reset returns true
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserDisagreeToAll", consentUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click user status with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // First click returns true
      await tester.tap(userStatusBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserStatus", consentUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click user status 2nd time", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Second click returns false
      await tester.tap(userStatusBtnFinder);
      await tester.pumpAndSettle();

      consentChanged = false;

      assertNativeMessage("setUserStatus", consentNotUpdatedMessage);

      assert(consentChanged == false);
      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click user status after reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      consentChanged = false;
      // First click returns false (already clicked before)
      await tester.tap(userStatusBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserStatus", consentNotUpdatedMessage);

      assert(consentChanged == false);
      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // Click after reset returns true
      await tester.tap(userStatusBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserStatus", consentUpdatedMessage);

      assert(consentChanged == true);
      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click global user status with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // First click returns true
      await tester.tap(userStatusGloballyBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserStatusGlobally", consentUpdatedMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click global user status 2nd time", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Second click returns false
      await tester.tap(userStatusGloballyBtnFinder);
      await tester.pumpAndSettle();

      consentChanged = false;

      assertNativeMessage("setUserStatusGlobally", consentNotUpdatedMessage);

      assert(consentChanged == false);
      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click global user status after reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      consentChanged = false;
      // First click returns false (already clicked before)
      await tester.tap(userStatusGloballyBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserStatusGlobally", consentNotUpdatedMessage);

      assert(consentChanged == false);
      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // Click after reset returns true
      await tester.tap(userStatusGloballyBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserStatusGlobally", consentUpdatedMessage);

      assert(consentChanged == true);
      assert(isError == false);
      assert(isReady == true);
    });
  });
}
