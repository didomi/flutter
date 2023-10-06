import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_vendor_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Native message strings.
  const emptyDisabledVendorMessage = "Native message: Disabled Vendor list is empty.";
  const emptyEnabledVendorMessage = "Native message: Enabled Vendor list is empty.";
  const vendorIdListInMessage = ["google", "827", "1000"];
  const suffixVendorMessage = "([^,]+,\\s)+[^,]+\\.";
  const disabledVendorMessage = "Native message: Disabled Vendors: $suffixVendorMessage";
  const enabledVendorMessage = "Native message: Enabled Vendors: $suffixVendorMessage";
  const requiredVendorMessage = "Native message: Required Vendors: $suffixVendorMessage";
  const vendorNames = "Exponential Interactive, Inc d/b/a VDX.tv, Index Exchange Inc., Fifty Technology Limited,";

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
    /// Without initialization

    testWidgets("Get disabled vendor ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendorIds", notReadyMessage);

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

      assertNativeMessage("getEnabledVendorIds", notReadyMessage);

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

      assertNativeMessage("getRequiredVendorIds", notReadyMessage);

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

      assertNativeMessage("getDisabledVendors", notReadyMessage);

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

      assertNativeMessage("getEnabledVendors", notReadyMessage);

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

      assertNativeMessage("getRequiredVendors", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get a vendor name without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getVendor", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    /// With initialization

    testWidgets("Get disabled vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledVendorIds", emptyDisabledVendorMessage);

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

      assertNativeMessage("getEnabledVendorIds", emptyEnabledVendorMessage);

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

      assertNativeMessageMatch("getRequiredVendorIds", requiredVendorMessage);
      assertNativeMessageContains("getRequiredVendorIds", vendorIdListInMessage);

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

      assertNativeMessage("getDisabledVendors", emptyDisabledVendorMessage);

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

      assertNativeMessage("getEnabledVendors", emptyEnabledVendorMessage);

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

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /// With initialization + Agree to All

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

      assertNativeMessage("getDisabledVendorIds", emptyDisabledVendorMessage);

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

      assertNativeMessageMatch("getEnabledVendorIds", enabledVendorMessage);
      assertNativeMessageContains("getEnabledVendorIds", vendorIdListInMessage);

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

      assertNativeMessageMatch("getRequiredVendorIds", requiredVendorMessage);
      assertNativeMessageContains("getRequiredVendorIds", vendorIdListInMessage);

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

      assertNativeMessage("getDisabledVendors", emptyDisabledVendorMessage);

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

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /// With initialization + Disagree to All

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

      assertNativeMessageMatch("getDisabledVendorIds", disabledVendorMessage);
      assertNativeMessageContains("getDisabledVendorIds", vendorIdListInMessage);

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

      assertNativeMessage("getEnabledVendorIds", emptyEnabledVendorMessage);

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

      assertNativeMessageMatch("getRequiredVendorIds", requiredVendorMessage);
      assertNativeMessageContains("getRequiredVendorIds", vendorIdListInMessage);

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

      assertNativeMessage("getEnabledVendors", emptyEnabledVendorMessage);

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

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: Google Advertising Products.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
