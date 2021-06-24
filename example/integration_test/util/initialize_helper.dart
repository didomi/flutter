import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

class InitializeHelper {
  static Future initialize(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();

    // Wait for sdk init
    await tester.runAsync(() async {
      while (await DidomiSdk.isReady == false) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      await expectLater(await DidomiSdk.isReady, isTrue);
    });
  }
}
