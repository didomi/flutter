import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_initialize_custom_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final isReadyBtnFinder = find.byKey(Key("isReady"));
  final onReadyBtnFinder = find.byKey(Key("onReady"));
  final initializeBtnFinder = find.byKey(Key("initialize"));

  bool isError = false;
  bool isReady = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };

  DidomiSdk.addEventListener(listener);

  group("Initialize Success", () {
    testWidgets("Initialize with default parameters", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      // SDK is not ready at startup
      assertNativeMessage("isReady", "Native message: Result = false");

      await tester.tap(onReadyBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("isReady", "Native message: Waiting for onReady callback");

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 4));

      assertNativeMessage("initialize", "Native message: OK");

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      // SDK is ready
      assertNativeMessage("isReady", "Native message: Result = true");
      assertNativeMessage("onReady", "Native message: SDK is ready!");

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
