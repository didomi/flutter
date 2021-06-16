import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_preferences_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initialize_helper.dart';

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

  DidomiSdk.addEventListener(listener);

  group("Show Preferences", () {
    testWidgets("Show Preferences without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(showPreferencesBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Don't check DidomiSdk.isPreferencesVisible (SDK not initialized)
    });

    testWidgets("Show Preferences with initialization for purpose", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(purposesCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(hideCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(showPreferencesBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Preferences dialog is visible
      assert(await DidomiSdk.isPreferencesVisible == true);

      // Wait for dialog to close
      await Future.delayed(Duration(seconds: 4));

      // Preferences dialog is NOT visible anymore
      assert(await DidomiSdk.isPreferencesVisible == false);
    });

    testWidgets("Show Preferences with initialization for vendor", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(vendorsCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(hideCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(showPreferencesBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Preferences dialog is visible
      assert(await DidomiSdk.isPreferencesVisible == true);

      // Wait for dialog to close
      await Future.delayed(Duration(seconds: 4));

      // Preferences dialog is NOT visible anymore
      assert(await DidomiSdk.isPreferencesVisible == false);
    });
  });
}
