// @dart=2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Log Level", () {
    final setLogLevelBtnFinder = find.byValueKey("setLogLevel");

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    // TODO('Find a way to get Platform - it returns the platform device launching UI tests')
    // More info here: https://github.com/flutter/flutter/issues/32927
    test("Set Log Level", () async {
      await driver.tap(setLogLevelBtnFinder);
      // Check SDK is not ready at startup
      expect(driver.getText(find.byValueKey("nativeResponse_setLogLevel")).then((field) => expect(field, startsWith("Native message: Level is error ("))),
          completes);
    });
  });
}
