// @dart=2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("User Consent for Vendor and Required Purposes", () {
    final initializeBtnFinder = find.byValueKey("initializeSmall");
    final agreeToAllBtnFinder = find.byValueKey("setUserAgreeToAll");
    final disagreeToAllBtnFinder = find.byValueKey("setUserDisagreeToAll");
    final getUserConsentStatusForVendorAndRequiredPurposeBtnFinder = find.byValueKey("getUserConsentStatusForVendorAndRequiredPurposes");

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

    test("Click get user consent for vendor 'c:pinterest' and required purpose without initialization", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "false");

      await driver.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_getUserConsentStatusForVendorAndRequiredPurposes")).then(
              (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    /*
     * With initialization
     */

    test("Click get user consent for vendor 'c:pinterest' and required purpose with initialization", () async {
      await driver.tap(initializeBtnFinder);
      await Future.delayed(Duration(seconds: 1));

      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_getUserConsentStatusForVendorAndRequiredPurposes"))
              .then((field) => expect(field, contains("Native message: User status is 'Disabled' for vendor 'c:pinterest'."))),
          completes);
    });

    /*
     * With initialization + agree
     */

    test("Click get user consent for vendor 'c:pinterest' and required purpose with initialization after agree", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(agreeToAllBtnFinder);

      await driver.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_getUserConsentStatusForVendorAndRequiredPurposes"))
              .then((field) => expect(field, contains("Native message: User status is 'Enabled' for vendor 'c:pinterest'."))),
          completes);
    });

    /*
     * With initialization + disagree
     */

    test("Click get user consent for vendor 'c:pinterest' and required purpose with initialization after disagree", () async {
      String onReadyReceived = await driver.requestData("isOnReadyReceived");
      assert(onReadyReceived == "true");

      await driver.tap(disagreeToAllBtnFinder);

      await driver.tap(getUserConsentStatusForVendorAndRequiredPurposeBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_getUserConsentStatusForVendorAndRequiredPurposes"))
              .then((field) => expect(field, contains("Native message: User status is 'Disabled' for vendor 'c:pinterest'."))),
          completes);
    });
  });
}
