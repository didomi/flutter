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
  const vendorIdListInMessage = ["1111", "217", "272"];
  const suffixVendorMessage = "([^,]+,\\s)+[^,]+\\.";
  const requiredVendorMessage = "Native message: Required Vendors: $suffixVendorMessage";
  const vendorNames = "152 Media LLC, 2KDirect, Inc. (dba iPromote), A.Mob.";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final requiredVendorIdsBtnFinder = find.byKey(Key("getRequiredVendorIds"));
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

    testWidgets("Get required vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessageMatch("getRequiredVendorIds", requiredVendorMessage);
      assertNativeMessageContains("getRequiredVendorIds", vendorIdListInMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required vendor names with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

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

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      // Depending on the screen size, we might need to scroll more than once
      // in order to reach the widgets at the bottom of the list.
      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getVendorBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Vendor: 152 Media LLC.";
      assertNativeMessage("getVendor", expected);

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
