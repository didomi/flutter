// @dart=2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  group('Initialize', () {
    final isReadyBtnFinder = find.byValueKey('isReady');
    final onReadyBtnFinder = find.byValueKey('onReady');
    final initializeBtnFinder = find.byValueKey('initialize');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Is ready', () async {
      String onReadyReceived = await driver.requestData('isOnReadyReceived');
      assert(onReadyReceived == 'false');

      await driver.tap(isReadyBtnFinder);
      // Check SDK is not ready at startup
      expect(
          driver.getText(find.byValueKey("nativeResponse_isReady")).then((field) =>
              expect(field, contains("Native message: Result = false"))),
          completes);

      await driver.tap(initializeBtnFinder);

      await waitForSdkReady(driver, onReadyBtnFinder);

      await driver.tap(isReadyBtnFinder);
      // Check SDK is ready afterwards
      expect(
          driver.getText(find.byValueKey("nativeResponse_isReady")).then((field) =>
            expect(field, contains("Native message: Result = true"))),
          completes);

      onReadyReceived = await driver.requestData('isOnReadyReceived');
      assert(onReadyReceived == 'true');
    });
  });

  group('Open UI', () {
    final isReadyBtnFinder = find.byValueKey('isReady');
    final onReadyBtnFinder = find.byValueKey('onReady');
    final initializeBtnFinder = find.byValueKey('initialize');
    final setupUIBtnFinder = find.byValueKey('setupUI');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Setup UI', () async {
      // Check notice was not displayed before startup
      String noticeDisplayed = await driver.requestData('isNoticeDisplayed');
      assert(noticeDisplayed == 'false');

      await driver.tap(setupUIBtnFinder);
      expect(
          driver.getText(find.byValueKey("nativeResponse_setupUI")).then((field) =>
              expect(field, contains("Native message: OK"))),
          completes);

      await driver.tap(initializeBtnFinder);
      waitForSdkReady(driver, onReadyBtnFinder);

      // We let some time for notice to be hidden
      await Future.delayed(Duration(seconds: 2), () {});
      noticeDisplayed = await driver.requestData('isNoticeDisplayed');
      assert(noticeDisplayed == 'true');
    });
  });
}

Future waitForSdkReady(FlutterDriver driver, SerializableFinder onReadyBtnFinder) async {
  await driver.tap(onReadyBtnFinder);
  await driver.waitFor(find.text("Native message: SDK is ready!\n"), timeout: Duration(seconds: 20));
  expect(
      driver.getText(find.byValueKey("nativeResponse_onReady")).then((field) =>
          expect(field, contains("Native message: SDK is ready!"))),
      completes);
}