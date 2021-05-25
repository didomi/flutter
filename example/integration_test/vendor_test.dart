import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_vendor_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initializeHelper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final disabledVendorIdsBtnFinder = find.byKey(Key("getDisabledVendorIds"));
  final enabledVendorIdsBtnFinder = find.byKey(Key("getEnabledVendorIds"));
  final requiredVendorIdsBtnFinder = find.byKey(Key("getRequiredVendorIds"));

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getDisabledVendorIds") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getEnabledVendorIds") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getRequiredVendorIds") &&
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

    testWidgets("Get disabled vendor ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getDisabledVendorIds") &&
              widget.data?.contains("Native message: Disabled Vendor list is empty.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getEnabledVendorIds") &&
              widget.data?.contains("Native message: Enabled Vendor list is empty.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getRequiredVendorIds") &&
              widget.data?.startsWith("Native message: Required Vendors: 1,10,100,1000,1001,1002,") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getDisabledVendorIds") &&
              widget.data?.contains("Native message: Disabled Vendor list is empty.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getEnabledVendorIds") &&
              widget.data?.startsWith("Native message: Enabled Vendors: 1,10,100,1000,1001,1002,") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getRequiredVendorIds") &&
              widget.data?.startsWith("Native message: Required Vendors: 1,10,100,1000,1001,1002,") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + Disagree to All
     */

    testWidgets("Get disabled vendor ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledVendorIdsBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getDisabledVendorIds") &&
              widget.data?.startsWith("Native message: Disabled Vendors: 1,10,100,1000,1001,1002,") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getEnabledVendorIds") &&
              widget.data?.contains("Native message: Enabled Vendor list is empty.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getRequiredVendorIds") &&
              widget.data?.startsWith("Native message: Required Vendors: 1,10,100,1000,1001,1002,") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
