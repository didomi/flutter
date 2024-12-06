import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

class InitializeHelper {
  static const initializationTimeout = Duration(seconds: 20);

  static Future initialize(WidgetTester tester, Finder finder) async {

    await tester.tap(finder);
    await tester.pumpAndSettle();

    final startTime = DateTime.now();
    // Wait for sdk init
    await tester.runAsync(() async {
      while (await DidomiSdk.isReady == false && DateTime.now().difference(startTime) < initializationTimeout) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      await expectLater(await DidomiSdk.isReady, isTrue);
    });
    await Future.delayed(Duration(milliseconds: 100));
  }
}
