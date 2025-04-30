import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/current_user_status.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_current_user_status_tests.dart' as app;
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

  group("Current User Status information", () {
    testWidgets("Get current user status without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      var exceptionThrown = false;
      try {
        await DidomiSdk.currentUserStatus;
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

      var result = await DidomiSdk.currentUserStatus;
      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature not enabled (empty string)
      assert(result.gppString == ""); // GPP feature not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            'measure_ad_performance',
            'create_ads_profile',
            'device_characteristics',
            'cookies',
            'geolocation_data',
            'improve_products',
            'market_research',
            'select_basic_ads',
            'select_personalized_ads',
          ]));

      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "cookies", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_basic_ads", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "measure_ad_performance", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "improve_products", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "create_ads_profile", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_personalized_ads", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "market_research", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "geolocation_data", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "device_characteristics", enabled: false));

      // Vendors
      expect(
          result.vendors?.keys,
          containsAll([
            "152media-Aa6Z6mLC",
            "ipromote",
            "amob-Vd2fVzAM",
          ]));

      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-Vd2fVzAM", enabled: false));
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

      var result = await DidomiSdk.currentUserStatus;

      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature not enabled (empty string)
      assert(result.gppString == ""); // GPP feature not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            'measure_ad_performance',
            'create_ads_profile',
            'device_characteristics',
            'cookies',
            'geolocation_data',
            'improve_products',
            'market_research',
            'select_basic_ads',
            'select_personalized_ads',
          ]));

      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "cookies", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_basic_ads", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "measure_ad_performance", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "improve_products", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "create_ads_profile", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_personalized_ads", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "market_research", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "geolocation_data", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "device_characteristics", enabled: true));

      // Vendors
      expect(
          result.vendors?.keys,
          containsAll([
            "152media-Aa6Z6mLC",
            "ipromote",
            "amob-Vd2fVzAM",
          ]));

      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: true));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: true));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-Vd2fVzAM", enabled: true));
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

      var result = await DidomiSdk.currentUserStatus;

      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature not enabled (empty string)
      assert(result.gppString == ""); // GPP feature not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            'measure_ad_performance',
            'create_ads_profile',
            'device_characteristics',
            'cookies',
            'geolocation_data',
            'improve_products',
            'market_research',
            'select_basic_ads',
            'select_personalized_ads',
          ]));

      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "cookies", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_basic_ads", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "measure_ad_performance", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "improve_products", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "create_ads_profile", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_personalized_ads", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "market_research", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "geolocation_data", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "device_characteristics", enabled: false));

      // Vendors
      expect(
          result.vendors?.keys,
          containsAll([
            "152media-Aa6Z6mLC",
            "ipromote",
            "amob-Vd2fVzAM",
          ]));

      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-Vd2fVzAM", enabled: false));
    });
  });
}
