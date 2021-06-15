import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_user_consent_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserAgreeToAll") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserDisagreeToAll") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserStatus") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserStatusGlobally") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );
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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserAgreeToAll") && widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);

      // Second click returns false
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserAgreeToAll") && widget.data?.contains("Native message: Consent updated: false.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserAgreeToAll") && widget.data?.contains("Native message: Consent updated: false.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // Click after reset returns true
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserAgreeToAll") && widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserDisagreeToAll") &&
              widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);

      // Second click returns false
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserDisagreeToAll") &&
              widget.data?.contains("Native message: Consent updated: false.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserDisagreeToAll") &&
              widget.data?.contains("Native message: Consent updated: false.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // Click after reset returns true
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserDisagreeToAll") &&
              widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserStatus") && widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserStatus") && widget.data?.contains("Native message: Consent updated: false.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserStatus") && widget.data?.contains("Native message: Consent updated: false.") == true,
        ),
        findsOneWidget,
      );

      assert(consentChanged == false);
      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // Click after reset returns true
      await tester.tap(userStatusBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserStatus") && widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserStatusGlobally") && widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserStatusGlobally") && widget.data?.contains("Native message: Consent updated: false.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserStatusGlobally") && widget.data?.contains("Native message: Consent updated: false.") == true,
        ),
        findsOneWidget,
      );

      assert(consentChanged == false);
      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // Click after reset returns true
      await tester.tap(userStatusGloballyBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserStatusGlobally") && widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

      assert(consentChanged == true);
      assert(isError == false);
      assert(isReady == true);
    });
  });
}
