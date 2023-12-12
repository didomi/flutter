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
  const purposeNames = "$purpose1Name, Create a personalised ads profile, Create a personalised content profile, "
      "Actively scan device characteristics for identification, Use precise geolocation data, Develop and improve products, "
      "Apply market research to generate audience insights, Measure ad performance, Measure content performance, Select basic ads, "
      "Select personalised ads, Select personalised content.";
  const purposeIds = "cookies, create_ads_profile, create_content_profile, device_characteristics, geolocation_data, improve_products, market_research, "
      "measure_ad_performance, measure_content_performance, select_basic_ads, select_personalized_ads, select_personalized_content.";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final disabledPurposeIdsBtnFinder = find.byKey(Key("getDisabledPurposeIds"));
  final enabledPurposeIdsBtnFinder = find.byKey(Key("getEnabledPurposeIds"));
  final requiredPurposeIdsBtnFinder = find.byKey(Key("getRequiredPurposeIds"));
  final disabledPurposesBtnFinder = find.byKey(Key("getDisabledPurposes"));
  final enabledPurposesBtnFinder = find.byKey(Key("getEnabledPurposes"));
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

    testWidgets("Get disabled purpose ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(disabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledPurposeIds", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get enabled purpose ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(enabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledPurposeIds", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

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

    testWidgets("Get disabled purpose names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(disabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getDisabledPurposes", notReadyMessage);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get enabled purpose names without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await tester.tap(enabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getEnabledPurposes", notReadyMessage);

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

    testWidgets("Get a purpose name without initialization", (WidgetTester tester) async {
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

    testWidgets("Get disabled purpose ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Purpose list is empty.";
      assertNativeMessage("getDisabledPurposeIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled purpose ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Purpose list is empty.";
      assertNativeMessage("getEnabledPurposeIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

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

    testWidgets("Get disabled purpose names with initialization", (WidgetTester tester) async {
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
      await tester.tap(disabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Purpose list is empty.";
      assertNativeMessage("getDisabledPurposes", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled purpose names with initialization", (WidgetTester tester) async {
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
      await tester.tap(enabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Purpose list is empty.";
      assertNativeMessage("getEnabledPurposes", expected);

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

    testWidgets("Get a purpose name with initialization", (WidgetTester tester) async {
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

      final expected = "Native message: Purpose: $purpose1Name.";
      assertNativeMessage("getPurpose", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /// With initialization + Agree to All

    testWidgets("Get disabled purpose ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(disabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Purpose list is empty.";
      assertNativeMessage("getDisabledPurposeIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled purpose ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Purposes: $purposeIds";
      assertNativeMessage("getEnabledPurposeIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required purpose ids with initialization and user agreed", (WidgetTester tester) async {
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

    testWidgets("Get disabled purpose names with initialization and user agreed", (WidgetTester tester) async {
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
      await tester.tap(disabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Purpose list is empty.";
      assertNativeMessage("getDisabledPurposes", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled purpose names with initialization and user agreed", (WidgetTester tester) async {
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
      await tester.tap(enabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Purposes: $purposeNames";
      assertNativeMessage("getEnabledPurposes", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required purpose names with initialization and user agreed", (WidgetTester tester) async {
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

    testWidgets("Get a purpose name with initialization and user agreed", (WidgetTester tester) async {
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

      final expected = "Native message: Purpose: $purpose1Name.";
      assertNativeMessage("getPurpose", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /// With initialization + Disagree to All

    testWidgets("Get disabled purpose ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Purposes: $purposeIds";
      assertNativeMessage("getDisabledPurposeIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled purpose ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Purpose list is empty.";
      assertNativeMessage("getEnabledPurposeIds", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required purpose ids with initialization and user agreed", (WidgetTester tester) async {
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

    testWidgets("Get disabled purpose names with initialization and user disagreed", (WidgetTester tester) async {
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
      await tester.tap(disabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Disabled Purposes: $purposeNames";
      assertNativeMessage("getDisabledPurposes", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled purpose names with initialization and user disagreed", (WidgetTester tester) async {
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
      await tester.tap(enabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Enabled Purpose list is empty.";
      assertNativeMessage("getEnabledPurposes", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required purpose names with initialization and user disagreed", (WidgetTester tester) async {
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

    testWidgets("Get a purpose name with initialization and user disagreed", (WidgetTester tester) async {
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

      final expected = "Native message: Purpose: $purpose1Name.";
      assertNativeMessage("getPurpose", expected);

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
