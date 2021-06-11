import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_purpose_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  // Native message strings.
  final purposeNames = "purpose_1_name, purpose_3_name, purpose_5_name, special_feature_2_name, special_feature_1_name, purpose_10_name, purpose_9_name, purpose_7_name, purpose_8_name, purpose_2_name, purpose_4_name, purpose_6_name.";
  final purposeIds = "cookies,create_ads_profile,create_content_profile,device_characteristics,geolocation_data,improve_products,market_research,measure_ad_performance,measure_content_performance,select_basic_ads,select_personalized_ads,select_personalized_content.";
  final notReadyMessage = "Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.";

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };

  DidomiSdk.addEventListener(listener);

  group("Purpose", () {
    /*
     * Without initialization
     */

    testWidgets("Get disabled purpose ids without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(disabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getDisabledPurposeIds", expected);

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

      final expected = notReadyMessage;
      assertNativeMessage("getEnabledPurposeIds", expected);

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

      final expected = notReadyMessage;
      assertNativeMessage("getRequiredPurposeIds", expected);

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

      final expected = notReadyMessage;
      assertNativeMessage("getDisabledPurposes", expected);

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

      final expected = notReadyMessage;
      assertNativeMessage("getEnabledPurposes", expected);

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

      final expected = notReadyMessage;
      assertNativeMessage("getRequiredPurposes", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get a purpose name without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);
      await scrollDown(tester, listKey);
      await tester.tap(getPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = notReadyMessage;
      assertNativeMessage("getPurpose", expected);

      assert(isError == false);
      assert(isReady == false);
    });

    /*
     * With initialization
     */

    testWidgets("Get disabled purpose ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

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

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await scrollDown(tester, listKey);
      await tester.tap(getPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Purpose: purpose_1_name.";
      assertNativeMessage("getPurpose", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + Agree to All
     */

    testWidgets("Get disabled purpose ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

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

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await scrollDown(tester, listKey);
      await tester.tap(getPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Purpose: purpose_1_name.";
      assertNativeMessage("getPurpose", expected);

      assert(isError == false);
      assert(isReady == true);
    });

    /*
     * With initialization + Disagree to All
     */

    testWidgets("Get disabled purpose ids with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

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

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);
      await scrollDown(tester, listKey);
      await tester.tap(getPurposesBtnFinder);
      await tester.pumpAndSettle();

      final expected = "Native message: Purpose: purpose_1_name.";
      assertNativeMessage("getPurpose", expected);

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
