import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

class InitializeHelper {
  static const initializationTimeout = Duration(seconds: 20);

  /// Tap [finder] to initialize the SDK and wait until it is ready.
  ///
  /// [isReady] lets callers also wait for their own `onReady` event listener to
  /// have run. The method channel reports readiness before the event channel has
  /// dispatched `onReady`, so tests asserting on a listener-backed flag right
  /// after this call would otherwise race the event. Pass the flag as a getter
  /// (e.g. `isReady: () => isReady`) so it is re-read on every poll.
  static Future initialize(WidgetTester tester, Finder finder, {bool Function()? isReady}) async {

    await tester.tap(finder);
    await tester.pumpAndSettle();

    final startTime = DateTime.now();
    // Wait for sdk init
    await tester.runAsync(() async {
      while (await DidomiSdk.isReady == false && DateTime.now().difference(startTime) < initializationTimeout) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      await expectLater(await DidomiSdk.isReady, isTrue);

      // Wait for the onReady event to reach the caller's listener.
      while (isReady != null && isReady() == false && DateTime.now().difference(startTime) < initializationTimeout) {
        await Future.delayed(Duration(milliseconds: 100));
      }
    });

    if (isReady != null) {
      await expectLater(isReady(), isTrue, reason: "onReady event was not received before timeout");
    }
  }
}
