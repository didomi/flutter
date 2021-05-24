import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_setup_ui_tests.dart' as setupUIApp;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final setupUIBtnFinder = find.byKey(Key("setupUI"));

  bool isError = false;
  bool isReady = false;
  bool noticeWasShown = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };
  listener.onShowNotice = () {
    noticeWasShown = true;
  };

  group("Setup UI", () {
    testWidgets("Reset SDK for bulk action", (WidgetTester tester) async {
      try {
        DidomiSdk.reset();
      } catch (ignored) {}

      isError = false;
      isReady = false;
      noticeWasShown = false;

      DidomiSdk.addEventListener(listener);

      assert(isError == false);
      assert(isReady == false);
      assert(noticeWasShown == false);
    });

    testWidgets("Setup UI and initialize after", (WidgetTester tester) async {
      // Start setupUIApp
      setupUIApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(setupUIBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("setupUI") && widget.data?.contains("Native message: OK") == true,
        ),
        findsOneWidget,
      );

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      // TODO('Check for dialog')

      await Future.delayed(Duration(seconds: 2));

      assert(isError == false);
      assert(isReady == true);
      assert(noticeWasShown == true);
    });
  });
}
