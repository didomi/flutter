import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_user_li_for_purpose_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));
  final resetBtnFinder = find.byKey(Key("reset"));
  final getUserLegitimateInterestStatusForPurposeBtnFinder = find.byKey(Key("getUserLegitimateInterestStatusForPurpose"));

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

  group("User Legitimate Interest for ", () {
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

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
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

    testWidgets("Click LI for purpose 'cookie' with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      // TODO('Check difference')
      if (Platform.isAndroid) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: User status is 'Enabled' for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      } else if (Platform.isIOS) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: No user status for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets("Click LI for purpose 'cookie' after agreeing then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Agree
      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text && widget.key.toString().contains("setUserAgreeToAll") && widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

      // Check LI
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      // TODO('Check difference')
      if (Platform.isAndroid) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: User status is 'Enabled' for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      } else if (Platform.isIOS) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: No user status for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      }

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

      // TODO('Check difference')
      if (Platform.isAndroid) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: User status is 'Enabled' for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      } else if (Platform.isIOS) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: No user status for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets("Click LI for purpose 'cookie' after disagreeing then reset", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Agree
      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("setUserDisagreeToAll") &&
              widget.data?.contains("Native message: Consent updated: true.") == true,
        ),
        findsOneWidget,
      );

      // Check LI
      await tester.tap(getUserLegitimateInterestStatusForPurposeBtnFinder);
      await tester.pumpAndSettle();

      // TODO('Check difference')
      if (Platform.isAndroid) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: User status is 'Enabled' for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      } else if (Platform.isIOS) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: No user status for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      }

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

      // TODO('Check difference')
      if (Platform.isAndroid) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: User status is 'Enabled' for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      } else if (Platform.isIOS) {
        expect(
          find.byWidgetPredicate(
                (Widget widget) =>
            widget is Text &&
                widget.key.toString().contains("getUserLegitimateInterestStatusForPurpose") &&
                widget.data?.contains("Native message: No user status for purpose 'cookies'.") == true,
          ),
          findsOneWidget,
        );
      }
    });
  });
}
