import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_user_li_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Messages
  const enabledForPurposeMessage = "Native message: User status is 'Enabled' for purpose 'cookies'.";
  const enabledForVendorMessage = "Native message: User status is 'Enabled' for vendor 'google'.";
  const enabledForVendorAndRequiredPurposesMessage = "Native message: User status is 'Enabled' for vendor 'google' and required purposes.";
  const disabledForVendorAndRequiredPurposesMessage = "Native message: User status is 'Disabled' for vendor 'google' and required purposes.";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final resetBtnFinder = find.byKey(Key("reset"));
  final getUserLegitimateInterestStatusForPurposeBtnFinder = find.byKey(Key("getUserLegitimateInterestStatusForPurpose"));
  final getUserLegitimateInterestStatusForVendorBtnFinder = find.byKey(Key("getUserLegitimateInterestStatusForVendor"));
  final getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder = find.byKey(Key("getUserLegitimateInterestStatusForVendorAndRequiredPurposes"));
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

  group("User Legitimate Interest for Vendor", () {

    testWidgets("Click LI without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // UserLegitimateInterestStatusForPurpose
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", notReadyMessage);

      // UserLegitimateInterestStatusForVendor
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", notReadyMessage);

      await scrollDown(tester, listKey);

      // UserLegitimateInterestStatusForVendorAndRequiredPurposes
      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });


    testWidgets("Click LI with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      // UserLegitimateInterestStatusForPurpose
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);

      // UserLegitimateInterestStatusForVendor
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await scrollDown(tester, listKey);

      // UserLegitimateInterestStatusForVendorAndRequiredPurposes
      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", enabledForVendorAndRequiredPurposesMessage);
    });

    testWidgets("Click LI after agreeing then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      // Agree
      await tester.tap(agreeToAllBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("setUserAgreeToAll", "Native message: Consent updated: true.");

      // UserLegitimateInterestStatusForPurpose
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);

      // getUserLegitimateInterestStatusForVendor
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await scrollDown(tester, listKey);

      // UserLegitimateInterestStatusForVendorAndRequiredPurposes
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

      // UserLegitimateInterestStatusForPurpose
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);

      // UserLegitimateInterestStatusForVendor
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await scrollDown(tester, listKey);

      // UserLegitimateInterestStatusForVendorAndRequiredPurposes
      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", enabledForVendorAndRequiredPurposesMessage);
    });

    testWidgets("Click LI after disagreeing then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      // Disagree
      await tester.tap(disagreeToAllBtnFinder);

      // Wait consent to be updated
      await Future.delayed(Duration(seconds: 1));
      await tester.pumpAndSettle();

      assertNativeMessage("setUserDisagreeToAll", "Native message: Consent updated: true.");

      // UserLegitimateInterestStatusForPurpose
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);

      // UserLegitimateInterestStatusForVendor
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await scrollDown(tester, listKey);

      // UserLegitimateInterestStatusForVendorAndRequiredPurposes
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

      // UserLegitimateInterestStatusForPurpose
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);

      // UserLegitimateInterestStatusForVendor
      await tester.tap(getUserLegitimateInterestStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendor", enabledForVendorMessage);

      await scrollDown(tester, listKey);

      // UserLegitimateInterestStatusForVendorAndRequiredPurposes
      await tester.tap(getUserLegitimateInterestStatusForVendorAndRequiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", enabledForVendorAndRequiredPurposesMessage);
    });
  });
}
