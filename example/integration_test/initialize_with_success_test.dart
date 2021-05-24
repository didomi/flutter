import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_initialize_custom_tests.dart' as initializeWithSuccessApp;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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

  group("Initialize Success", () {
    testWidgets("Reset SDK for bulk action", (WidgetTester tester) async {
      try {
        DidomiSdk.reset();
      } catch (ignored) {}

      isError = false;
      isReady = false;

      DidomiSdk.addEventListener(listener);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Initialize with default parameters", (WidgetTester tester) async {
      // Start initializeWithSuccessApp
      initializeWithSuccessApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      // SDK is not ready at startup
      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("isReady") && widget.data?.contains("Native message: Result = false") == true,
        ),
        findsOneWidget,
      );

      await tester.tap(onReadyBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.key.toString().contains("onReady") && widget.data?.contains("Native message: Waiting for onReady callback") == true,
        ),
        findsOneWidget,
      );

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 2));

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("initialize") && widget.data?.contains("Native message: OK") == true,
        ),
        findsOneWidget,
      );

      await tester.tap(isReadyBtnFinder);
      await tester.pumpAndSettle();

      // SDK is ready
      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("isReady") && widget.data?.contains("Native message: Result = true") == true,
        ),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("onReady") && widget.data?.contains("Native message: SDK is ready!") == true,
        ),
        findsOneWidget,
      );

      assert(isError == false);
      assert(isReady == true);
    });
  });
}
