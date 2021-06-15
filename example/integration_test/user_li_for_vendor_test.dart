import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_user_li_for_vendor_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final resetBtnFinder = find.byKey(Key("reset"));
  final getUserLegitimateInterestStatusForVendorBtnFinder = find.byKey(Key("getUserLegitimateInterestStatusForVendor"));
  final getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder = find.byKey(Key("getUserLegitimateInterestStatusForVendorAndRequiredPurposes"));

  // Messages
  final notReadyMessage = "Native message: Failed: 'Didomi SDK is not ready. Use the onReady callback to access this method.'.";
  final enabledForVendorMessage = "Native message: User status is 'Enabled' for vendor '738'.";
  final disabledForVendorMessage = "Native message: User status is 'Disabled' for vendor '738'.";
  final enabledForVendorAndRequiredPurposesMessage = "Native message: User status is 'Enabled' for vendor '738' and required purposes.";
  final disabledForVendorAndRequiredPurposesMessage = "Native message: User status is 'Disabled' for vendor '738' and required purposes.";

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

  group("User Legitimate Interest for Vendor", () {
    /*
     * Without initialization
     */

    testWidgets("Click LI for vendor '738' without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // UserLegitimateInterestStatusForVendor
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", notReadyMessage);

      // UserLegitimateInterestStatusForVendorAndRequiredPurposes
      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    /*
     * With initialization
     */

    testWidgets("Click LI for vendor '738' with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", enabledForVendorAndRequiredPurposesMessage);
    });

    /*
     * With initialization + agree then reset
     */
    testWidgets("Click LI for vendor '738' after agreeing then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Agree
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserAgreeToAll", "Native message: Consent updated: true.");

      // Check LI
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", enabledForVendorAndRequiredPurposesMessage);

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Check LI (no change)
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", enabledForVendorAndRequiredPurposesMessage);
    });

    /*
     * With initialization + disagree then reset
     */
    testWidgets("Click LI for vendor '738' after disagreeing then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Agree
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("setUserDisagreeToAll", "Native message: Consent updated: true.");

      // Check LI
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", disabledForVendorMessage);

      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", disabledForVendorAndRequiredPurposesMessage);

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Check LI (reverted)
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", enabledForVendorAndRequiredPurposesMessage);
    });
  });
}
