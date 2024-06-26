import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_get_user_status_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'util/assertion_helper.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final initializeBtnFinder = find.byKey(Key("initializeSmall"));

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

  group("User Status information", () {
    testWidgets("Get user status without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      var exceptionThrown = false;
      try {
        // ignore: deprecated_member_use
        await DidomiSdk.userStatus;
      } on PlatformException {
        exceptionThrown = true;
      }
      assert(exceptionThrown);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get user status with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      // ignore: deprecated_member_use
      var result = await DidomiSdk.userStatus;
      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDCS == ""); // DCS feature flag not enabled (empty string)

      assertListEmpty(result.purposes?.consent?.enabled);
      assertListEmpty(result.purposes?.consent?.disabled);
      assertListEmpty(result.purposes?.legitimateInterest?.enabled);
      assertListEmpty(result.purposes?.legitimateInterest?.disabled);
      assertListEmpty(result.vendors?.consent?.enabled);
      assertListEmpty(result.vendors?.consent?.disabled);
      assertListEmpty(result.vendors?.legitimateInterest?.enabled);
      assertListEmpty(result.vendors?.legitimateInterest?.disabled);
    });

    testWidgets("Get user status after agree to all", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      var statusSet = await DidomiSdk.setUserAgreeToAll();
      assert(statusSet);

      // ignore: deprecated_member_use
      var result = await DidomiSdk.userStatus;

      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDCS == ""); // DCS feature flag not enabled (empty string)

      assertListContains(result.purposes?.consent?.enabled, "cookies");
      assertListEmpty(result.purposes?.consent?.disabled);
      assertListContains(result.purposes?.legitimateInterest?.enabled, "improve_products");
      assertListEmpty(result.purposes?.legitimateInterest?.disabled);
      assertListContains(result.purposes?.global?.enabled, "cookies");
      assertListEmpty(result.purposes?.global?.disabled);

      assertListContains(result.vendors?.consent?.enabled, "217");
      assertListEmpty(result.vendors?.consent?.disabled);
      assertListContains(result.vendors?.legitimateInterest?.enabled, "217");
      assertListEmpty(result.vendors?.legitimateInterest?.disabled);
      assertListContains(result.vendors?.global?.enabled, "217");
      assertListEmpty(result.vendors?.global?.disabled);
      assertListContains(result.vendors?.globalConsent?.enabled, "217");
      assertListEmpty(result.vendors?.globalConsent?.disabled);
      assertListContains(result.vendors?.globalLegitimateInterest?.enabled, "217");
      assertListEmpty(result.vendors?.globalLegitimateInterest?.disabled);
    });

    testWidgets("Get user status after disagree to all", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      var statusSet = await DidomiSdk.setUserDisagreeToAll();
      assert(statusSet);

      // ignore: deprecated_member_use
      var result = await DidomiSdk.userStatus;

      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDCS == ""); // DCS feature flag not enabled (empty string)

      assertListEmpty(result.purposes?.consent?.enabled);
      assertListContains(result.purposes?.consent?.disabled, "cookies");
      assertListEmpty(result.purposes?.legitimateInterest?.enabled);
      assertListContains(result.purposes?.legitimateInterest?.disabled, "improve_products");
      assertListEmpty(result.purposes?.global?.enabled);
      assertListContains(result.purposes?.global?.disabled, "cookies");

      assertListEmpty(result.vendors?.consent?.enabled);
      assertListContains(result.vendors?.consent?.disabled, "217");
      assertListEmpty(result.vendors?.legitimateInterest?.enabled);
      assertListContains(result.vendors?.legitimateInterest?.disabled, "217");
      assertListDoesNotContain(result.vendors?.global?.enabled, "217");
      assertListContains(result.vendors?.global?.disabled, "217");
      assertListEmpty(result.vendors?.globalConsent?.enabled);
      assertListContains(result.vendors?.globalConsent?.disabled, "217");
      assertListEmpty(result.vendors?.globalLegitimateInterest?.enabled);
      assertListContains(result.vendors?.globalLegitimateInterest?.disabled, "217");
    });
  });
}
