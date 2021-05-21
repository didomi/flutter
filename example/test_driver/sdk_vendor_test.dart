// @dart=2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Vendor", () {
    final initializeBtnFinder = find.byValueKey("initializeSmall");
    final agreeToAllBtnFinder = find.byValueKey("setUserAgreeToAll");
    final disagreeToAllBtnFinder = find.byValueKey("setUserDisagreeToAll");
    final disabledVendorIdsBtnFinder = find.byValueKey("getDisabledVendorIds");
    final enabledVendorIdsBtnFinder = find.byValueKey("getEnabledVendorIds");
    final requiredVendorIdsBtnFinder = find.byValueKey("getRequiredVendorIds");

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

      await driver.tap(disabledVendorIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getDisabledVendorIds")).then(
              (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    test("Get enabled purpose ids without initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "false");

      await driver.tap(enabledVendorIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getEnabledVendorIds")).then(
              (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    test("Get required purpose ids without initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "false");

      await driver.tap(requiredVendorIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getRequiredVendorIds")).then(
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

      await driver.tap(disabledVendorIdsBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_getDisabledVendorIds"))
              .then((field) => expect(field, contains("Native message: Disabled Vendors list is empty."))),
          completes);
    });

    test("Get enabled purpose ids with initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(enabledVendorIdsBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_getEnabledVendorIds"))
              .then((field) => expect(field, contains("Native message: Enabled Vendors list is empty."))),
          completes);
    });

    test("Get required purpose ids with initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(requiredVendorIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getRequiredVendorIds")).then((field) => expect(
              field,
              contains(
                  "Native message: Required Vendors: 164,284,402,413,91,c:ab-tasty,c:adjust-JZUjXFCR,c:contentsquare,c:facebook-dmtCpRLw,c:omniture-adobe-analytics,c:pinterest,c:snapchat-b8Vdit6J,c:tiktok-KZAUQLZ9,c:tradedoubler,google."))),
          completes);
    });

    /*
     * With initialization + Agree to All
     */

    test("Get disabled purpose ids with initialization and user agreed", () async {
      await driver.tap(agreeToAllBtnFinder);

      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(disabledVendorIdsBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_getDisabledVendorIds"))
              .then((field) => expect(field, contains("Native message: Disabled Vendors list is empty."))),
          completes);
    });

    test("Get enabled purpose ids with initialization and user agreed", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(enabledVendorIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getEnabledVendorIds")).then((field) => expect(
              field,
              contains(
                  "Native message: Enabled Vendors: 164,284,402,413,91,c:ab-tasty,c:adjust-JZUjXFCR,c:contentsquare,c:facebook-dmtCpRLw,c:omniture-adobe-analytics,c:pinterest,c:snapchat-b8Vdit6J,c:tiktok-KZAUQLZ9,c:tradedoubler,google."))),
          completes);
    });

    test("Get required purpose ids with initialization and user agreed", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(requiredVendorIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getRequiredVendorIds")).then((field) => expect(
              field,
              contains(
                  "Native message: Required Vendors: 164,284,402,413,91,c:ab-tasty,c:adjust-JZUjXFCR,c:contentsquare,c:facebook-dmtCpRLw,c:omniture-adobe-analytics,c:pinterest,c:snapchat-b8Vdit6J,c:tiktok-KZAUQLZ9,c:tradedoubler,google."))),
          completes);
    });

    /*
     * With initialization + Disagree to All
     */

    test("Get disabled purpose ids with initialization and user agreed", () async {
      await driver.tap(disagreeToAllBtnFinder);

      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(disabledVendorIdsBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_getDisabledVendorIds"))
              .then((field) => expect(field, contains("Native message: Disabled Vendors: 164,284,402,413,91,c:ab-tasty,c:adjust-JZUjXFCR,c:contentsquare,c:facebook-dmtCpRLw,c:omniture-adobe-analytics,c:pinterest,c:snapchat-b8Vdit6J,c:tiktok-KZAUQLZ9,c:tradedoubler,google."))),
          completes);
    });

    test("Get enabled purpose ids with initialization and user agreed", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(enabledVendorIdsBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_getEnabledVendorIds"))
              .then((field) => expect(field, contains("Native message: Enabled Vendors list is empty."))),
          completes);
    });

    test("Get required purpose ids with initialization and user agreed", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(requiredVendorIdsBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getRequiredVendorIds")).then((field) => expect(
              field,
              contains(
                  "Native message: Required Vendors: 164,284,402,413,91,c:ab-tasty,c:adjust-JZUjXFCR,c:contentsquare,c:facebook-dmtCpRLw,c:omniture-adobe-analytics,c:pinterest,c:snapchat-b8Vdit6J,c:tiktok-KZAUQLZ9,c:tradedoubler,google."))),
          completes);
    });
  });
}
