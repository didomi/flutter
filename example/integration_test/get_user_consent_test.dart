import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_get_user_consent_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const disabledStatusForPurposeMessage = "Native message: User status is 'Disabled' for purpose 'cookies'.";
  const enabledStatusForPurposeMessage = "Native message: User status is 'Enabled' for purpose 'cookies'.";
  const noStatusForPurposeMessage = "Native message: No user status for purpose 'cookies'.";
  const disabledStatusForVendorMessage = "Native message: User status is 'Disabled' for vendor '738'.";
  const enabledStatusForVendorMessage = "Native message: User status is 'Enabled' for vendor '738'.";
  const noStatusForVendorMessage = "Native message: No user status for vendor '738'.";
  const disabledStatusForVendorAndRequiredPurposesMessage = "Native message: User status is 'Disabled' for vendor '738' and required purposes.";
  const enabledStatusForVendorAndRequiredPurposesMessage = "Native message: User status is 'Enabled' for vendor '738' and required purposes.";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final resetBtnFinder = find.byKey(Key("reset"));
  final getUserConsentStatusForPurposeBtnFinder = find.byKey(Key("getUserConsentStatusForPurpose"));
  final getUserConsentStatusForVendorBtnFinder = find.byKey(Key("getUserConsentStatusForVendor"));
  final getUserConsentStatusForVendorAndRequiredPurposeBtnFinder = find.byKey(Key("getUserConsentStatusForVendorAndRequiredPurposes"));
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

  group("User Consent for Vendor", () {
    testWidgets("Get user consent without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // UserConsentStatusForPurpose
      await tester.tap(getUserConsentStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForPurpose", notReadyMessage);

      // UserConsentStatusForVendor
      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendor", notReadyMessage);

      await scrollDown(tester, listKey);

      // UserConsentStatusForVendorAndRequiredPurposes
      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendorAndRequiredPurposes", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get user consent with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      // UserConsentStatusForPurpose
      await tester.tap(getUserConsentStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForPurpose", noStatusForPurposeMessage);

      // UserConsentStatusForVendor
      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendor", noStatusForVendorMessage);

      await scrollDown(tester, listKey);

      // UserConsentStatusForVendorAndRequiredPurposes
      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendorAndRequiredPurposes", disabledStatusForVendorAndRequiredPurposesMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get user consent with initialization after agree then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Agree to all
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      // UserConsentStatusForPurpose
      await tester.tap(getUserConsentStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForPurpose", enabledStatusForPurposeMessage);

      // UserConsentStatusForVendor
      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendor", enabledStatusForVendorMessage);

      await scrollDown(tester, listKey);

      // UserConsentStatusForVendorAndRequiredPurposes
      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendorAndRequiredPurposes", enabledStatusForVendorAndRequiredPurposesMessage);

      assert(isError == false);
      assert(isReady == true);

      await scrollUp(tester, listKey);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // UserConsentStatusForPurpose
      await tester.tap(getUserConsentStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForPurpose", noStatusForPurposeMessage);

      // UserConsentStatusForVendor
      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      await scrollDown(tester, listKey);

      assertNativeMessage("getUserConsentStatusForVendor", noStatusForVendorMessage);

      // UserConsentStatusForVendorAndRequiredPurposes
      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendorAndRequiredPurposes", disabledStatusForVendorAndRequiredPurposesMessage);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get user consent with initialization after disagree then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Disagree to all
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      // UserConsentStatusForPurpose
      await tester.tap(getUserConsentStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForPurpose", disabledStatusForPurposeMessage);

      // UserConsentStatusForVendor
      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendor", disabledStatusForVendorMessage);

      await scrollDown(tester, listKey);

      // UserConsentStatusForVendorAndRequiredPurposes
      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      await scrollDown(tester, listKey);

      assertNativeMessage("getUserConsentStatusForVendorAndRequiredPurposes", disabledStatusForVendorAndRequiredPurposesMessage);

      assert(isError == false);
      assert(isReady == true);

      await scrollUp(tester, listKey);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // UserConsentStatusForPurpose
      await tester.tap(getUserConsentStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForPurpose", noStatusForPurposeMessage);

      // UserConsentStatusForVendor
      await tester.tap(getUserConsentStatusForVendorBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendor", noStatusForVendorMessage);

      await scrollDown(tester, listKey);

      // UserConsentStatusForVendorAndRequiredPurposes
      await tester.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserConsentStatusForVendorAndRequiredPurposes", disabledStatusForVendorAndRequiredPurposesMessage);

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
