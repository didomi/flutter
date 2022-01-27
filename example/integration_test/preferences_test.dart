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
  bool preferencesWasHidden = false;
  bool preferencesWasShown = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };
  listener.onHidePreferences = () {
    preferencesWasHidden = true;
  };
  listener.onShowPreferences = () {
    preferencesWasShown = true;
  };

  DidomiSdk.addEventListener(listener);

  group("Show Preferences", () {
    testWidgets("Show Preferences without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);
      assert(preferencesWasHidden == false);
      assert(preferencesWasShown == false);

      await tester.tap(showPreferencesBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);
      assert(preferencesWasHidden == false);
      assert(preferencesWasShown == false);

      // Don't check DidomiSdk.isPreferencesVisible (SDK not initialized)
    });

    testWidgets("Show Preferences with initialization for purpose", (WidgetTester tester) async {
      preferencesWasHidden = false;
      preferencesWasShown = false;

      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);
      assert(preferencesWasHidden == false);
      assert(preferencesWasShown == false);

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
      assert(preferencesWasHidden == false);
      assert(preferencesWasShown == true);

      // Wait for dialog to close
      await Future.delayed(Duration(seconds: 4));

      // Preferences dialog is NOT visible anymore
      assert(await DidomiSdk.isPreferencesVisible == false);
      assert(preferencesWasHidden == true);
    });

    testWidgets("Show Preferences with initialization for vendor", (WidgetTester tester) async {
      preferencesWasHidden = false;
      preferencesWasShown = false;

      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);
      assert(preferencesWasHidden == false);
      assert(preferencesWasShown == false);

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
      assert(preferencesWasHidden == false);
      assert(preferencesWasShown == true);

      // Wait for dialog to close
      await Future.delayed(Duration(seconds: 4));

      // Preferences dialog is NOT visible anymore
      assert(await DidomiSdk.isPreferencesVisible == false);
      assert(preferencesWasHidden == true);
    });
  });
}
