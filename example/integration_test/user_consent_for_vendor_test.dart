import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_user_consent_for_vendor_tests.dart' as userConsentForVendorApp;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final getUserConsentStatusForVendorBtnFinder = find.byKey(Key("getUserConsentStatusForVendor"));

  bool isError = false;
  bool isReady = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };

  group("User Consent for Vendor", () {
    testWidgets("Reset SDK for bulk action", (WidgetTester tester) async {
      try {
        DidomiSdk.reset();
      } catch (ignored) {}

      isError = false;
      isReady = false;

      DidomiSdk.addEventListener(listener);

      assert(isError == false);
      assert(isReady == false);
    });

    /*
     * Without initialization
     */

    testWidgets("Click get user consent for vendor '1' without initialization", (WidgetTester tester) async {
      // Start userConsentForVendorApp
      userConsentForVendorApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getUserConsentStatusForVendor") &&
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

    testWidgets("Initialize for following scenarios", (WidgetTester tester) async {
      // Start userConsentForVendorApp
      userConsentForVendorApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Click get user consent for vendor '1' with initialization", (WidgetTester tester) async {
      // Start userConsentForVendorApp
      userConsentForVendorApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getUserConsentStatusForVendor") &&
              widget.data?.contains("Native message: No user status for vendor '1'.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + agree
     */

    testWidgets("Click get user consent for vendor '1' with initialization after agree", (WidgetTester tester) async {
      // Start userConsentForVendorApp
      userConsentForVendorApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getUserConsentStatusForVendor") &&
              widget.data?.contains("Native message: User status is 'Enabled' for vendor '1'.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + disagree
     */

    testWidgets("Click get user consent for vendor '1' with initialization after disagree", (WidgetTester tester) async {
      // Start userConsentForVendorApp
      userConsentForVendorApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getUserConsentStatusForVendor") &&
              widget.data?.contains("Native message: User status is 'Disabled' for vendor '1'.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });
  });
}