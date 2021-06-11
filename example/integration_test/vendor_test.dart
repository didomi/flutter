import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_vendor_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final disabledVendorIdsBtnFinder = find.byKey(Key("getDisabledVendorIds"));
  final enabledVendorIdsBtnFinder = find.byKey(Key("getEnabledVendorIds"));
  final requiredVendorIdsBtnFinder = find.byKey(Key("getRequiredVendorIds"));
  final disabledVendorsBtnFinder = find.byKey(Key("getDisabledVendors"));
  final enabledVendorsBtnFinder = find.byKey(Key("getEnabledVendors"));
  final requiredVendorsBtnFinder = find.byKey(Key("getRequiredVendors"));
  final getVendorBtnFinder = find.byKey(Key("getVendor"));
  final listKey = Key("components_list");

  // Native message strings.
  final vendorNames = "Exponential Interactive, Inc d/b/a VDX.tv, Index Exchange, Inc. , Fifty";
  final notReadyMessage = "Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.";

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

  group("Vendor", () {
    /*
     * Without initialization
     */

    testWidgets("Get disabled vendor ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getDisabledVendorIds", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get enabled vendor ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(enabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getEnabledVendorIds", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get required vendor ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getRequiredVendorIds", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get disabled vendor names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(disabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getDisabledVendors", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get enabled vendor names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(enabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getEnabledVendors", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get required vendor names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(requiredVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getRequiredVendors", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get a vendor name without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await scrollDown(tester, listKey);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    /*
     * With initialization
     */

    testWidgets("Get disabled vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Vendor list is empty.";
      assertNativeMessage("getDisabledVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Vendor list is empty.";
      assertNativeMessage("getEnabledVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: 1,10,100,1000,1001,1002,";
      assertNativeMessageStartsWith("getRequiredVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get disabled vendor names with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(disabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Vendor list is empty.";
      assertNativeMessage("getDisabledVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor names with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(enabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Vendor list is empty.";
      assertNativeMessage("getEnabledVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor names with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(requiredVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: $vendorNames";
      assertNativeMessageStartsWith("getRequiredVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get a vendor name with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await scrollDown(tester, listKey);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + Agree to All
     */

    testWidgets("Get disabled vendor ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Vendor list is empty.";
      assertNativeMessage("getDisabledVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Vendors: 1,10,100,1000,1001,1002,";
      assertNativeMessageStartsWith("getEnabledVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: 1,10,100,1000,1001,1002,";
      assertNativeMessageStartsWith("getRequiredVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get disabled vendor names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(disabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Vendor list is empty.";
      assertNativeMessage("getDisabledVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(enabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Vendors: $vendorNames";
      assertNativeMessageStartsWith("getEnabledVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(requiredVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: $vendorNames";
      assertNativeMessageStartsWith("getRequiredVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get a vendor name with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await scrollDown(tester, listKey);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + Disagree to All
     */

    testWidgets("Get disabled vendor ids with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Vendors: 1,10,100,1000,1001,1002,";
      assertNativeMessageStartsWith("getDisabledVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor ids with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Vendor list is empty.";
      assertNativeMessage("getEnabledVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor ids with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: 1,10,100,1000,1001,1002,";
      assertNativeMessageStartsWith("getRequiredVendorIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get disabled vendor names with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(disabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Vendors: $vendorNames";
      assertNativeMessageStartsWith("getDisabledVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled vendor names with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(enabledVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Vendor list is empty.";
      assertNativeMessage("getEnabledVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor names with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await tester.tap(requiredVendorsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Vendors: $vendorNames";
      assertNativeMessageStartsWith("getRequiredVendors", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get a vendor name with initialization and user disagreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await scrollDown(tester, listKey);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
