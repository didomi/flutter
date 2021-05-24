import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_preferences_tests.dart' as preferencesApp;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final showPreferencesBtnFinder = find.byKey(Key("showPreferences"));
  final purposesCbFinder = find.byKey(Key("PreferencesForPurposes"));
  final vendorsCbFinder = find.byKey(Key("PreferencesForVendors"));
  final hideCbFinder = find.byKey(Key("hidePreferencesAfterAWhile"));

  bool isError = false;
  bool isReady = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };

  group("Show Preferences", () {
    testWidgets("Reset SDK for bulk action", (WidgetTester tester) async {
      try {
        DidomiSdk.reset();
      } catch (ignored) {}

      isError = false;
      isReady = false;

      DidomiSdk.addEventListener(listener);
    });

    testWidgets("Show Preferences without initialization", (WidgetTester tester) async {
      // Start preferencesApp
      preferencesApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(showPreferencesBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("showPreferences") &&
              widget.data
                      ?.contains("Native message: Failed: \'An error occurred: Didomi SDK is not ready. Use the onReady callback to access this method.\'.") ==
                  true,
        ),
        findsOneWidget,
      );

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // TODO('Check for NO dialog')
    });

    testWidgets("Initialize for following scenarios", (WidgetTester tester) async {
      // Start preferencesApp
      preferencesApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);
    });

    testWidgets("Show Preferences with initialization for purpose", (WidgetTester tester) async {
      // Start preferencesApp
      preferencesApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(purposesCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(hideCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(showPreferencesBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("showPreferences") && widget.data?.contains("Native message: OK") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);

      // TODO('Check for dialogs')
      await Future.delayed(Duration(seconds: 4));
    });

    testWidgets("Show Preferences with initialization for vendors", (WidgetTester tester) async {
      // Start preferencesApp
      preferencesApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(vendorsCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(hideCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(showPreferencesBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("showPreferences") && widget.data?.contains("Native message: OK") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);

      // TODO('Check for dialogs')
      await Future.delayed(Duration(seconds: 4));
    });
  });
}
