// @dart=2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Purpose", () {
    final initializeBtnFinder = find.byValueKey("initializeSmall");
    final agreeToAllBtnFinder = find.byValueKey("setUserAgreeToAll");
    final disagreeToAllBtnFinder = find.byValueKey("setUserDisagreeToAll");
    final disabledPurposeIdsBtnFinder = find.byValueKey("getDisabledPurposeIds");
    final enabledPurposeIdsBtnFinder = find.byValueKey("getEnabledPurposeIds");
    final requiredPurposeIdsBtnFinder = find.byValueKey("getRequiredPurposeIds");

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    /*
     * Without initialization
     */

    test("Get disabled purpose ids without initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "false");

      await driver.tap(disabledPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getDisabledPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    test("Get enabled purpose ids without initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "false");

      await driver.tap(enabledPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getEnabledPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    test("Get required purpose ids without initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "false");

      await driver.tap(requiredPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getRequiredPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    /*
     * With initialization
     */

    test("Get disabled purpose ids with initialization", () async {
      await driver.tap(initializeBtnFinder);
      await Future.delayed(Duration(seconds: 1));

      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(disabledPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getDisabledPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Disabled Purposes list is empty."))),
          completes);
    });

    test("Get enabled purpose ids with initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(enabledPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getEnabledPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Enabled Purposes: technical."))),
          completes);
    });

    test("Get required purpose ids with initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(requiredPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getRequiredPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Required Purposes: cookies,create_ads_profile,create_content_profile,device_characteristics,geolocation_data,improve_products,market_research,measure_ad_performance,measure_content_performance,select_basic_ads,select_personalized_ads,select_personalized_content,technical."))),
          completes);
    });

    /*
     * With initialization + Agree to All
     */

    test("Get disabled purpose ids with initialization and user agreed", () async {
      await driver.tap(agreeToAllBtnFinder);

      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(disabledPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getDisabledPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Disabled Purposes list is empty."))),
          completes);
    });

    test("Get enabled purpose ids with initialization and user agreed", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(enabledPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getEnabledPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Enabled Purposes: cookies,create_ads_profile,create_content_profile,device_characteristics,geolocation_data,improve_products,market_research,measure_ad_performance,measure_content_performance,select_basic_ads,select_personalized_ads,select_personalized_content,technical."))),
          completes);
    });

    test("Get required purpose ids with initialization and user agreed", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(requiredPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getRequiredPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Required Purposes: cookies,create_ads_profile,create_content_profile,device_characteristics,geolocation_data,improve_products,market_research,measure_ad_performance,measure_content_performance,select_basic_ads,select_personalized_ads,select_personalized_content,technical."))),
          completes);
    });

    /*
     * With initialization + Disagree to All
     */

    test("Get disabled purpose ids with initialization and user agreed", () async {
      await driver.tap(disagreeToAllBtnFinder);

      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(disabledPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getDisabledPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Disabled Purposes: cookies,create_ads_profile,create_content_profile,device_characteristics,geolocation_data,improve_products,market_research,measure_ad_performance,measure_content_performance,select_basic_ads,select_personalized_ads,select_personalized_content."))),
          completes);
    });

    test("Get enabled purpose ids with initialization and user agreed", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(enabledPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getEnabledPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Enabled Purposes: technical."))),
          completes);
    });

    test("Get required purpose ids with initialization and user agreed", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(requiredPurposeIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getRequiredPurposeIds")).then(
                  (field) => expect(field, contains("Native message: Required Purposes: cookies,create_ads_profile,create_content_profile,device_characteristics,geolocation_data,improve_products,market_research,measure_ad_performance,measure_content_performance,select_basic_ads,select_personalized_ads,select_personalized_content,technical."))),
          completes);
    });
  });
}
