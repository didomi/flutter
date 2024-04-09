import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_transactions_vendors_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  // Vendors buttons
  final enableVendorTransactionBtnFinder = find.byKey(Key("enableVendorTransaction"));
  final disableVendorTransactionBtnFinder = find.byKey(Key("disableVendorTransaction"));
  final enableVendorsTransactionBtnFinder = find.byKey(Key("enableVendorsTransaction"));
  final disableVendorsTransactionBtnFinder = find.byKey(Key("disableVendorsTransaction"));

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

  group("CurrentUserStatusTransaction - Single Vendors", () {
    testWidgets("Enable a single vendor updating the user status", (WidgetTester tester) async {
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
      await tester.tap(enableVendorTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("enableVendorTransaction", "Native message: Updated: true, Enabled: true.");
    });

    testWidgets("Enable a single vendor without updating the user status", (WidgetTester tester) async {
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
      await tester.tap(enableVendorTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("enableVendorTransaction", "Native message: Updated: false, Enabled: true.");
    });

    testWidgets("Disable a single vendor updating the user status", (WidgetTester tester) async {
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
      await tester.tap(disableVendorTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("disableVendorTransaction", "Native message: Updated: true, Enabled: false.");
    });

    testWidgets("Disable a single vendor without updating the user status", (WidgetTester tester) async {
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
      await tester.tap(disableVendorTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("disableVendorTransaction", "Native message: Updated: false, Enabled: false.");
    });
  });

  group("CurrentUserStatusTransaction - Multiple Vendors", () {
    testWidgets("Enable multiple vendors updating the user status", (WidgetTester tester) async {
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
      await tester.ensureVisible(enableVendorsTransactionBtnFinder);
      await tester.tap(enableVendorsTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("enableVendorsTransaction", "Native message: Updated: true, Enabled: true.");
    });

    testWidgets("Enable multiple vendors without updating the user status", (WidgetTester tester) async {
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
      await tester.tap(enableVendorsTransactionBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("enableVendorsTransaction", "Native message: Updated: false, Enabled: true.");
    });

    testWidgets("Disable multiple vendors updating the user status", (WidgetTester tester) async {
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
      await tester.tap(disableVendorsTransactionBtnFinder);

      // Wait for consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("disableVendorsTransaction", "Native message: Updated: true, Enabled: false.");
    });

    testWidgets("Disable multiple vendors without updating the user status", (WidgetTester tester) async {
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
      await tester.tap(disableVendorsTransactionBtnFinder);

      // Wait for consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("disableVendorsTransaction", "Native message: Updated: false, Enabled: false.");
    });
  });
}
