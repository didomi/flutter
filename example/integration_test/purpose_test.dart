import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_purpose_tests.dart' as app;
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
  const purpose1Name = "Store and/or access information on a device";
  const purpose1Description = "Cookies, device or similar onl...";
  const purposeNames = "$purpose1Name, Create profiles for personalised advertising, "
      "Actively scan device characteristics for identification, Use precise geolocation data, "
      "Develop and improve services, Understand audiences through statistics or combinations of data "
      "from different sources, Measure advertising performance, "
      "Use limited data to select advertising, Use profiles to select personalised advertising.";
  const purposeIds = "cookies, create_ads_profile, device_characteristics, geolocation_data, improve_products, "
      "market_research, measure_ad_performance, select_basic_ads, "
      "select_personalized_ads.";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final requiredPurposeIdsBtnFinder = find.byKey(Key("getRequiredPurposeIds"));
  final requiredPurposesBtnFinder = find.byKey(Key("getRequiredPurposes"));
  final getPurposesBtnFinder = find.byKey(Key("getPurpose"));
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

  group("Purpose", () {
    /// Without initialization

    testWidgets("Get required purpose ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(requiredPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getRequiredPurposeIds", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get required purpose names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(requiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getRequiredPurposes", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get a purpose info without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getPurpose", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    /// With initialization

    testWidgets("Get required purpose ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Purposes: $purposeIds";
      assertNativeMessage("getRequiredPurposeIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required purpose names with initialization", (WidgetTester tester) async {
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
      await tester.tap(requiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Required Purposes: $purposeNames";
      assertNativeMessage("getRequiredPurposes", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get a purpose info with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey, offsetY: 600);
      await tester.tap(getPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Purpose: $purpose1Name. Description: $purpose1Description";
      assertNativeMessage("getPurpose", expected);

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
