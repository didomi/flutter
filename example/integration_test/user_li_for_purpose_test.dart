import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_user_li_for_purpose_tests.dart' as app;
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
  final getUserLegitimateInterestStatusForPurposeBtnFinder = find.byKey(Key("getUserLegitimateInterestStatusForPurpose"));

  // Messages
  final notReadyMessage = "Native message: Failed: 'Didomi SDK is not ready. Use the onReady callback to access this method.'.";
  final enabledForPurposeMessage = "Native message: User status is 'Enabled' for purpose 'cookies'.";

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

  group("User Legitimate Interest for Purpose", () {
    /*
     * Without initialization
     */

    testWidgets("Click LI for purpose 'cookie' without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    /*
     * With initialization
     */

    testWidgets("Click LI for purpose 'cookie' with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);
    });

    /*
     * With initialization + agree then reset
     */
    testWidgets("Click LI for purpose 'cookie' after agreeing then reset", (WidgetTester tester) async {
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
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Check LI (no change)
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);
    });

    /*
     * With initialization + disagree then reset
     */
    testWidgets("Click LI for purpose 'cookie' after disagreeing then reset", (WidgetTester tester) async {
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
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);

      assert(isError == false);
      assert(isReady == true);

      // Reset user consent
      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Check LI (no change)
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getUserLegitimateInterestStatusForPurpose", enabledForPurposeMessage);
    });
  });
}
