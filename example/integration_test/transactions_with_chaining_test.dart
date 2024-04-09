import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_chaining_transactions_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final chainEnablePurposeTransactionsBtnFinder = find.byKey(Key("chainEnablePurposeTransactions"));
  final chainDisablePurposeTransactionsBtnFinder = find.byKey(Key("chainDisablePurposeTransactions"));
  final chainEnableVendorTransactionsBtnFinder = find.byKey(Key("chainEnableVendorTransactions"));
  final chainDisableVendorTransactionsBtnFinder = find.byKey(Key("chainDisableVendorTransactions"));

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

  group("CurrentUserStatusTransaction - Chain Purpose Transactions", () {
    testWidgets("Enable purposes by chaining calls updating the user status", (WidgetTester tester) async {
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
      await tester.tap(chainEnablePurposeTransactionsBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      const purposes = "(cookies, select_basic_ads, create_ads_profile, select_personalized_ads)";
      assertNativeMessage("chainEnablePurposeTransactions", "Native message: Updated: true, Enabled: $purposes.");
    });

    testWidgets("Disable purposes by chaining calls updating the user status", (WidgetTester tester) async {
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
      await tester.tap(chainDisablePurposeTransactionsBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      const purposes = "(cookies, select_basic_ads, create_ads_profile, select_personalized_ads)";
      assertNativeMessage("chainDisablePurposeTransactions", "Native message: Updated: true, Disabled: $purposes.");
    });

    testWidgets("Enable purposes by chaining calls without updating the user status", (WidgetTester tester) async {
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
      await tester.tap(chainEnablePurposeTransactionsBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      const purposes = "(cookies, select_basic_ads, create_ads_profile, select_personalized_ads)";
      assertNativeMessage("chainEnablePurposeTransactions", "Native message: Updated: false, Enabled: $purposes.");
    });

    testWidgets("Disable purposes by chaining calls without updating the user status", (WidgetTester tester) async {
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
      await tester.tap(chainDisablePurposeTransactionsBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      const purposes = "(cookies, select_basic_ads, create_ads_profile, select_personalized_ads)";
      assertNativeMessage("chainDisablePurposeTransactions", "Native message: Updated: false, Disabled: $purposes.");
    });
  });

  group("CurrentUserStatusTransaction - Chain Vendor Transactions", () {
    testWidgets("Enable vendors by chaining calls updating the user status", (WidgetTester tester) async {
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
      await tester.tap(chainEnableVendorTransactionsBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      const vendors = "(152media-Aa6Z6mLC, ipromote, amob-txzcQCyq)";
      assertNativeMessage("chainEnableVendorTransactions", "Native message: Updated: true, Enabled: $vendors.");
    });

    testWidgets("Disable vendors by chaining calls updating the user status", (WidgetTester tester) async {
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
      await tester.tap(chainDisableVendorTransactionsBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      const vendors = "(152media-Aa6Z6mLC, ipromote, amob-txzcQCyq)";
      assertNativeMessage("chainDisableVendorTransactions", "Native message: Updated: true, Disabled: $vendors.");
    });

    testWidgets("Enable vendors by chaining calls without updating the user status", (WidgetTester tester) async {
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
      await tester.tap(chainEnableVendorTransactionsBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      const vendors = "(152media-Aa6Z6mLC, ipromote, amob-txzcQCyq)";
      assertNativeMessage("chainEnableVendorTransactions", "Native message: Updated: false, Enabled: $vendors.");
    });

    testWidgets("Disable vendors by chaining calls without updating the user status", (WidgetTester tester) async {
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
      await tester.tap(chainDisableVendorTransactionsBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      const vendors = "(152media-Aa6Z6mLC, ipromote, amob-txzcQCyq)";
      assertNativeMessage("chainDisableVendorTransactions", "Native message: Updated: false, Disabled: $vendors.");
    });
  });
}
