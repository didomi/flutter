import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_transactions_purposes_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  // Purposes buttons
  final enablePurposeTransactionBtnFinder = find.byKey(Key("enablePurposeTransaction"));
  final disablePurposeTransactionBtnFinder = find.byKey(Key("disablePurposeTransaction"));
  final enablePurposesTransactionBtnFinder = find.byKey(Key("enablePurposesTransaction"));
  final disablePurposesTransactionBtnFinder = find.byKey(Key("disablePurposesTransaction"));

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

  group("CurrentUserStatusTransaction - Single Purposes", () {
    testWidgets("Enable Single Purposes With Changes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await DidomiSdk.setUserDisagreeToAll();
      // Agree
      await tester.tap(enablePurposeTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("enablePurposeTransaction", "Native message: Updated: true, Enabled: true.");
    });

    testWidgets("Enable Single Purposes Without Changes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await DidomiSdk.setUserAgreeToAll();
      // Agree
      await tester.tap(enablePurposeTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("enablePurposeTransaction", "Native message: Updated: false, Enabled: true.");
    });

    testWidgets("Disable Single Purpose With Changes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await DidomiSdk.setUserAgreeToAll();
      // Disagree
      await tester.tap(disablePurposeTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("disablePurposeTransaction", "Native message: Updated: true, Enabled: false.");
    });

    testWidgets("Disable Single Purpose Without Changes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await DidomiSdk.setUserDisagreeToAll();
      // Disagree
      await tester.tap(disablePurposeTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("disablePurposeTransaction", "Native message: Updated: false, Enabled: false.");
    });
  });

  group("CurrentUserStatusTransaction - Multiple Purposes", () {
    testWidgets("Enable Multiple Purposes With Changes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await DidomiSdk.setUserDisagreeToAll();
      // Agree
      await tester.tap(enablePurposesTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("enablePurposesTransaction", "Native message: Updated: true, Enabled: true.");
    });

    testWidgets("Enable Multiple Purposes Without Changes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await DidomiSdk.setUserAgreeToAll();
      // Agree
      await tester.tap(enablePurposesTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("enablePurposesTransaction", "Native message: Updated: false, Enabled: true.");
    });

    testWidgets("Disable Multiple Purposes With Changes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await DidomiSdk.setUserAgreeToAll();
      // Disagree
      await tester.tap(disablePurposesTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("disablePurposesTransaction", "Native message: Updated: true, Enabled: false.");
    });

    testWidgets("Disable Multiple Purposes Without Changes", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await DidomiSdk.setUserDisagreeToAll();
      // Disagree
      await tester.tap(disablePurposesTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("disablePurposesTransaction", "Native message: Updated: false, Enabled: false.");
    });
  });
}
