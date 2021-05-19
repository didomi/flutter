// @dart=2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  group('Initialize Error', () {
    final isReadyBtnFinder = find.byValueKey('isReady');
    final onErrorBtnFinder = find.byValueKey('onError');
    final initializeBtnFinder = find.byValueKey('initialize');
    final apiKeyFieldFinder = find.byValueKey('apiKey');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Has error', () async {
      await driver.tap(isReadyBtnFinder);
      // Check SDK is not ready at startup
      expect(
          driver.getText(find.byValueKey("nativeResponse_isReady")).then((field) =>
              expect(field, contains("Native message: Result = false"))),
          completes);

      // Check there was no error before startup
      String errorReceived = await driver.requestData('isOnErrorReceived');
      assert(errorReceived == 'false');

      await driver.tap(onErrorBtnFinder);

      await driver.tap(apiKeyFieldFinder);
      await driver.enterText("invalid-invalid-invalid-invalid-inva");
      await driver.tap(initializeBtnFinder);

      await driver.waitFor(find.text("Native message: SDK encountered an error\n"), timeout: Duration(seconds: 20));

      // Check error event was received
      errorReceived = await driver.requestData('isOnErrorReceived');
      assert(errorReceived == 'true');
    });
  });
}
