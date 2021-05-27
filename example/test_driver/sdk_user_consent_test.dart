// @dart=2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("User Consent", () {
    final initializeBtnFinder = find.byValueKey("initialize");
    final agreeToAllBtnFinder = find.byValueKey("setUserAgreeToAll");
    final disagreeToAllBtnFinder = find.byValueKey("setUserDisagreeToAll");
    final userStatusBtnFinder = find.byValueKey("setUserStatus");

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

    test("Click agree to all without initialization", () async {
      String onReadyReceived = await driver.requestData('isOnReadyReceived');
      assert(onReadyReceived == "false");

      await driver.tap(agreeToAllBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_setUserAgreeToAll")).then(
              (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    test("Click disagree to all without initialization", () async {
      String onReadyReceived = await driver.requestData('isOnReadyReceived');
      assert(onReadyReceived == "false");

      await driver.tap(disagreeToAllBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_setUserDisagreeToAll")).then(
              (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    test("Click user status without initialization", () async {
      String onReadyReceived = await driver.requestData('isOnReadyReceived');
      assert(onReadyReceived == "false");

      await driver.tap(userStatusBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_setUserStatus")).then(
              (field) => expect(field, contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'."))),
          completes);
    });

    /*
     * With initialization
     */

    test("Click agree to all with initialization", () async {
      await driver.tap(initializeBtnFinder);
      await Future.delayed(Duration(seconds: 1));

      String onReadyReceived = await driver.requestData('isOnReadyReceived');
      assert(onReadyReceived == "true");

      // Second click returns true
      await driver.tap(agreeToAllBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_setUserAgreeToAll"))
              .then((field) => expect(field, contains("Native message: Consent updated: true."))),
          completes);

      // Second click returns false
      await driver.tap(agreeToAllBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_setUserAgreeToAll"))
              .then((field) => expect(field, contains("Native message: Consent updated: false."))),
          completes);
    });

    test("Click disagree to all with initialization", () async {
      String onReadyReceived = await driver.requestData('isOnReadyReceived');
      assert(onReadyReceived == "true");

      // Second click returns true
      await driver.tap(disagreeToAllBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_setUserDisagreeToAll"))
              .then((field) => expect(field, contains("Native message: Consent updated: true."))),
          completes);

      // Second click returns false
      await driver.tap(disagreeToAllBtnFinder);
      expect(
          driver
              .getText(find.byValueKey("nativeResponse_setUserDisagreeToAll"))
              .then((field) => expect(field, contains("Native message: Consent updated: false."))),
          completes);
    });

    test("Click user status all with initialization", () async {
      String onReadyReceived = await driver.requestData('isOnReadyReceived');
      assert(onReadyReceived == "true");

      // Second click returns true
      await driver.tap(userStatusBtnFinder);
      expect(driver.getText(find.byValueKey("nativeResponse_setUserStatus")).then((field) => expect(field, contains("Native message: Consent updated: true."))),
          completes);

      // Second click returns false
      await driver.tap(userStatusBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_setUserStatus")).then((field) => expect(field, contains("Native message: Consent updated: false."))),
          completes);
    });
  });
}
