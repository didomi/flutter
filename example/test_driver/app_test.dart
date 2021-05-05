// @dart=2.9

// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  group('Didomi plugin', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final isReadyBtnFinder = find.byValueKey('isReady');
    final initializeBtnFinder = find.byValueKey('initialize');
    final setupUIBtnFinder = find.byValueKey('setupUI');
    final checkConsentBtnFinder = find.byValueKey('checkConsentBtn');
    final checkConsentResultFinder = find.byValueKey('checkConsentResult');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Initialize SDK', () async {
      await driver.tap(initializeBtnFinder);
      expect(await driver.getText(find.byValueKey("nativeResponse_initialize")), "Native message: OK\n");
    });

    test('Is ready', () async {
      await driver.tap(isReadyBtnFinder);
      // Check SDK is not ready at startup
      expect(await driver.getText(find.byValueKey("nativeResponse_isReady")), "Native message: Result = false\n");

      await driver.tap(initializeBtnFinder);
      // TODO listen to onReady instead
      await Future.delayed(Duration(seconds: 20), () {});
      await driver.tap(isReadyBtnFinder);
      // Check SDK is ready at startup
      expect(await driver.getText(find.byValueKey("nativeResponse_isReady")), "Native message: Result = true\n");
    });
  });
}