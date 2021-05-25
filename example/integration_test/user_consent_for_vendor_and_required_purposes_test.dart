import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_user_consent_for_vendor_and_required_purposes_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final getUserConsentStatusForVendorAndRequiredPurposeBtnFinder = find.byKey(Key("getUserConsentStatusForVendorAndRequiredPurposes"));

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

  group("User Consent for Vendor and Required Purposes", () {
    /*
     * Without initialization
     */

    testWidgets("Click get user consent for vendor '1' and required purpose without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getUserConsentStatusForVendorAndRequiredPurposes") &&
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

    testWidgets("Click get user consent for vendor '1' and required purpose with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getUserConsentStatusForVendorAndRequiredPurposes") &&
              widget.data?.contains("Native message: User status is 'Disabled' for vendor '1'.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + agree
     */

    testWidgets("Click get user consent for vendor '1' and required purpose with initialization after agree", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getUserConsentStatusForVendorAndRequiredPurposes") &&
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

    testWidgets("Click get user consent for vendor '1' and required purpose with initialization after disagree", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("getUserConsentStatusForVendorAndRequiredPurposes") &&
              widget.data?.contains("Native message: User status is 'Disabled' for vendor '1'.") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
