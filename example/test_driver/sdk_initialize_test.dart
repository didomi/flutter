// @dart=2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  group('Didomi plugin', () {
    final componentsListFinder = find.byValueKey('components_list');
    final isReadyBtnFinder = find.byValueKey('isReady');
    final onReadyBtnFinder = find.byValueKey('onReady');
    final initializeBtnFinder = find.byValueKey('initialize');
    final setupUIBtnFinder = find.byValueKey('setupUI');
    final eventsLoggerFinder = find.byValueKey('sdk_events_logger');
    final checkConsentBtnFinder = find.byValueKey('checkConsentBtn');
    final checkConsentResultFinder = find.byValueKey('checkConsentResult');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Initialize SDK', () async {
      await driver.tap(initializeBtnFinder);
      expect(await driver.getText(find.byValueKey("nativeResponse_initialize")),
          contains("Native message: OK"));
    });

    test('Is ready', () async {
      await driver.tap(isReadyBtnFinder);
      // Check SDK is not ready at startup
      expect(await driver.getText(find.byValueKey("nativeResponse_isReady")),
          contains("Native message: Result = false"));

      await driver.tap(initializeBtnFinder);

      await waitForSdkReady(driver, onReadyBtnFinder);

      await driver.tap(isReadyBtnFinder);
      // Check SDK is ready afterwards
      expect(await driver.getText(find.byValueKey("nativeResponse_isReady")),
          contains("Native message: Result = true"));
    });
  });

  group('Open UI', () {
    final componentsListFinder = find.byValueKey('components_list');
    final isReadyBtnFinder = find.byValueKey('isReady');
    final onReadyBtnFinder = find.byValueKey('onReady');
    final initializeBtnFinder = find.byValueKey('initialize');
    final setupUIBtnFinder = find.byValueKey('setupUI');
    final eventsLoggerFinder = find.byValueKey('sdk_events_logger');
    final checkConsentBtnFinder = find.byValueKey('checkConsentBtn');
    final checkConsentResultFinder = find.byValueKey('checkConsentResult');

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
      String noticeDisplayed = await driver.requestData('isNoticeDisplayed');
      assert(noticeDisplayed == 'false');

      await driver.tap(setupUIBtnFinder);
      expect(await driver.getText(find.byValueKey("nativeResponse_setupUI")), contains("Native message: OK"));

      await driver.tap(initializeBtnFinder);
      waitForSdkReady(driver, onReadyBtnFinder);

      noticeDisplayed = await driver.requestData('isNoticeDisplayed');
      assert(noticeDisplayed == 'true');
    });
  });
}

Future waitForSdkReady(FlutterDriver driver, SerializableFinder onReadyBtnFinder) async {
  await driver.tap(onReadyBtnFinder);
  await driver.waitFor(find.text("Native message: SDK is ready!\n"), timeout: Duration(seconds: 20));
  expect(await driver.getText(find.byValueKey("nativeResponse_onReady")), contains("Native message: SDK is ready!"));
}