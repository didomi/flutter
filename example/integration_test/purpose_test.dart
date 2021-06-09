import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_purpose_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'extensions/string_apis.dart';

import 'util/initialize_helper.dart';

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

  bool isError = false;
  bool isReady = false;

  final purposeNames = "Native message: Required Purposes: purpose_1_name, purpose_3_name, purpose_5_name, special_feature_2_name, special_feature_1_name, purpose_10_name, purpose_9_name, purpose_7_name, purpose_8_name, purpose_2_name, purpose_4_name, purpose_6_name.";

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getDisabledPurposeIds") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getEnabledPurposeIds") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getRequiredPurposeIds") &&
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

    testWidgets("Get disabled purpose ids with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledPurposeIdsBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getDisabledPurposeIds") &&
              widget.data?.contains("Native message: Disabled Purpose list is empty.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getEnabledPurposeIds") &&
              widget.data?.contains("Native message: Enabled Purpose list is empty.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getRequiredPurposeIds") &&
              widget.data?.startsWith("Native message: Required Purposes: cookies,create_ads_profile,create_content_profile,") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getDisabledPurposeIds") &&
              widget.data?.contains("Native message: Disabled Purpose list is empty.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getEnabledPurposeIds") &&
              widget.data?.startsWith("Native message: Enabled Purposes: cookies,create_ads_profile,create_content_profile,") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getRequiredPurposeIds") &&
              widget.data?.startsWith("Native message: Required Purposes: cookies,create_ads_profile,create_content_profile,") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getDisabledPurposeIds") &&
              widget.data?.startsWith("Native message: Disabled Purposes: cookies,create_ads_profile,create_content_profile,") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getEnabledPurposeIds") &&
              widget.data?.contains("Native message: Enabled Purpose list is empty.") == true,
        ),
        findsOneWidget,
      );

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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getRequiredPurposeIds") &&
              widget.data?.startsWith("Native message: Required Purposes: cookies,create_ads_profile,create_content_profile,") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get disabled purpose names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(disabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getDisabledPurposes")
        ),
        findsOneWidget,
      );

      const testKey = Key('nativeResponse_DisabledPurposes');
      var finder = find.byKey(testKey);
      var text = finder.evaluate().single.widget as Text;
      var actual = text.data!.removeNewLines();
      var expected = purposeNames;
      assert(actual == expected, "Actual: $actual\nExpected: $expected");

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get enabled purpose names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(enabledPurposesBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getEnabledPurposes")
        ),
        findsOneWidget,
      );

      const testKey = Key('nativeResponse_getEnabledPurposes');
      var finder = find.byKey(testKey);
      var text = finder.evaluate().single.widget as Text;
      var actual = text.data!.removeNewLines();
      var expected = purposeNames;
      assert(actual == expected, "Actual: $actual\nExpected: $expected");

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Get required purpose names with initialization and user agreed", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(requiredPurposesBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getRequiredPurposes")
        ),
        findsOneWidget,
      );

      const testKey = Key('nativeResponse_getRequiredPurposes');
      var finder = find.byKey(testKey);
      var text = finder.evaluate().single.widget as Text;
      var actual = text.data!.removeNewLines();
      var expected = purposeNames;
      assert(actual == expected, "Actual: $actual\nExpected: $expected");

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
