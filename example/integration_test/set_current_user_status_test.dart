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
    testWidgets("Set current user status without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      var exceptionThrown = false;
      try {
        await DidomiSdk.setCurrentUserStatus(CurrentUserStatus());
      } on PlatformException {
        exceptionThrown = true;
      }
      assert(exceptionThrown);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Set user status with initialization returns failure", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      var statusSet = await DidomiSdk.setCurrentUserStatus(CurrentUserStatus(purposes: {
        "cookies": PurposeStatus(id: "Hello", enabled: true),
        "select_basic_ads": PurposeStatus(id: "select_basic_ads", enabled: true),
        "geolocation_data": PurposeStatus(id: "geolocation_data", enabled: true),
      }, vendors: {
        "152media-Aa6Z6mLC": VendorStatus(id: "152media-Aa6Z6mLC", enabled: true),
        "ipromote": VendorStatus(id: "ipromote", enabled: true),
      }));

      assert(!statusSet);

      var result = await DidomiSdk.currentUserStatus;
      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature flag not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            "cookies",
            "select_basic_ads",
            "measure_ad_performance",
            "improve_products",
            "create_ads_profile",
            "select_personalized_ads",
            "market_research",
            "geolocation_data",
            "device_characteristics",
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
            "amob-txzcQCyq",
          ]));

      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-txzcQCyq", enabled: false));
    });

    testWidgets("Set user status for purposes only with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      var statusSet = await DidomiSdk.setCurrentUserStatus(CurrentUserStatus(purposes: {
        "cookies": PurposeStatus(id: "cookies", enabled: true),
        "select_basic_ads": PurposeStatus(id: "select_basic_ads", enabled: true),
        "geolocation_data": PurposeStatus(id: "geolocation_data", enabled: true),
      }));

      assert(statusSet);

      var result = await DidomiSdk.currentUserStatus;
      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature flag not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            "cookies",
            "select_basic_ads",
            "measure_ad_performance",
            "improve_products",
            "create_ads_profile",
            "select_personalized_ads",
            "market_research",
            "geolocation_data",
            "device_characteristics",
          ]));

      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "cookies", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_basic_ads", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "measure_ad_performance", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "improve_products", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "create_ads_profile", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_personalized_ads", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "market_research", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "geolocation_data", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "device_characteristics", enabled: false));

      // Vendors
      expect(
          result.vendors?.keys,
          containsAll([
            "152media-Aa6Z6mLC",
            "ipromote",
            "amob-txzcQCyq",
          ]));

      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-txzcQCyq", enabled: false));
    });

    testWidgets("Set user status for vendors only with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      var statusSet = await DidomiSdk.setCurrentUserStatus(CurrentUserStatus(vendors: {
        "152media-Aa6Z6mLC": VendorStatus(id: "152media-Aa6Z6mLC", enabled: true),
        "ipromote": VendorStatus(id: "ipromote", enabled: true),
        "amob-txzcQCyq": VendorStatus(id: "amob-txzcQCyq", enabled: true),
      }));

      assert(statusSet);

      var result = await DidomiSdk.currentUserStatus;
      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature flag not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            "cookies",
            "select_basic_ads",
            "measure_ad_performance",
            "improve_products",
            "create_ads_profile",
            "select_personalized_ads",
            "market_research",
            "geolocation_data",
            "device_characteristics",
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
            "amob-txzcQCyq",
          ]));

      // Vendors are disabled since all purposes are disabled
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-txzcQCyq", enabled: false));
    });

    testWidgets("Set user status with initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      var statusSet = await DidomiSdk.setCurrentUserStatus(CurrentUserStatus(purposes: {
        "cookies": PurposeStatus(id: "cookies", enabled: true),
        "select_basic_ads": PurposeStatus(id: "select_basic_ads", enabled: true),
        "measure_ad_performance": PurposeStatus(id: "measure_ad_performance", enabled: true),
        "measure_content_performance": PurposeStatus(id: "measure_content_performance", enabled: true),
        "improve_products": PurposeStatus(id: "improve_products", enabled: true),
        "use_limited_data_to_select_content": PurposeStatus(id: "use_limited_data_to_select_content", enabled: true),
        "select_personalized_ads": PurposeStatus(id: "select_personalized_ads", enabled: true),
      }, vendors: {
        "152media-Aa6Z6mLC": VendorStatus(id: "152media-Aa6Z6mLC", enabled: true),
      }));

      assert(statusSet);

      var result = await DidomiSdk.currentUserStatus;
      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature flag not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            "cookies",
            "select_basic_ads",
            "measure_ad_performance",
            "improve_products",
            "create_ads_profile",
            "select_personalized_ads",
            "market_research",
            "geolocation_data",
            "device_characteristics",
          ]));

      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "cookies", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_basic_ads", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "measure_ad_performance", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "improve_products", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "create_ads_profile", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_personalized_ads", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "market_research", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "geolocation_data", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "device_characteristics", enabled: false));

      // Vendors
      expect(
          result.vendors?.keys,
          containsAll([
            "152media-Aa6Z6mLC",
            "ipromote",
            "amob-txzcQCyq",
          ]));

      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: true));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-txzcQCyq", enabled: false));
    });

    // TODO: Understand this test
    testWidgets("Set user status after agree to all", (WidgetTester tester) async {
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

      statusSet = await DidomiSdk.setCurrentUserStatus(CurrentUserStatus(purposes: {
        "device_characteristics": PurposeStatus(id: "device_characteristics", enabled: false),
        "measure_ad_performance": PurposeStatus(id: "measure_ad_performance", enabled: true),
      },
      vendors: {
        "ipromote": VendorStatus(id: "ipromote", enabled: true),
      }));

      assert(statusSet);

      var result = await DidomiSdk.currentUserStatus;

      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature flag not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            "cookies",
            "select_basic_ads",
            "measure_ad_performance",
            "improve_products",
            "create_ads_profile",
            "select_personalized_ads",
            "market_research",
            "geolocation_data",
            "device_characteristics",
          ]));

      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "cookies", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_basic_ads", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "measure_ad_performance", enabled: true));
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
            "amob-txzcQCyq",
          ]));

      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: false));
      // False because the purposes is disabled
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-txzcQCyq", enabled: false));
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

      statusSet = await DidomiSdk.setCurrentUserStatus(CurrentUserStatus(purposes: {
        "cookies": PurposeStatus(id: "cookies", enabled: true),
        "select_basic_ads": PurposeStatus(id: "select_basic_ads", enabled: true),
        "measure_ad_performance": PurposeStatus(id: "measure_ad_performance", enabled: true),
        "measure_content_performance": PurposeStatus(id: "measure_content_performance", enabled: true),
        "improve_products": PurposeStatus(id: "improve_products", enabled: true),
        "use_limited_data_to_select_content": PurposeStatus(id: "use_limited_data_to_select_content", enabled: true),
        "select_personalized_ads": PurposeStatus(id: "select_personalized_ads", enabled: true),
      }, vendors: {
        "152media-Aa6Z6mLC": VendorStatus(id: "152media-Aa6Z6mLC", enabled: true),
      }));

      assert(statusSet);

      var result = await DidomiSdk.currentUserStatus;

      assertMatchesUuidPattern(result.userId);
      assertTextNotEmpty(result.consentString);
      assertMatchesDatePattern(result.created);
      assertMatchesDatePattern(result.updated);
      assert(result.regulation == "gdpr");
      assert(result.didomiDcs == ""); // DCS feature flag not enabled (empty string)

      // Purposes
      expect(
          result.purposes?.keys,
          containsAll([
            "cookies",
            "select_basic_ads",
            "measure_ad_performance",
            "improve_products",
            "create_ads_profile",
            "select_personalized_ads",
            "market_research",
            "geolocation_data",
            "device_characteristics",
          ]));

      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "cookies", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_basic_ads", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "measure_ad_performance", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "improve_products", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "create_ads_profile", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "select_personalized_ads", enabled: true));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "market_research", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "geolocation_data", enabled: false));
      assertPurposeStatusMapContains(result.purposes, PurposeStatus(id: "device_characteristics", enabled: false));

      // Vendors
      expect(
          result.vendors?.keys,
          containsAll([
            "152media-Aa6Z6mLC",
            "ipromote",
            "amob-txzcQCyq",
          ]));

      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "152media-Aa6Z6mLC", enabled: true));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "ipromote", enabled: false));
      assertVendorStatusMapContains(result.vendors, VendorStatus(id: "amob-txzcQCyq", enabled: false));
    });
  });
}
