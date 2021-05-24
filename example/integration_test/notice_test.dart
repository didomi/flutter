import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_notice_tests.dart' as noticeApp;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final showNoticeBtnFinder = find.byKey(Key("showNotice"));
  final hideNoticeCbFinder = find.byKey(Key("hideNotice"));

  bool isError = false;
  bool isReady = false;
  bool noticeWasHidden = false;
  bool noticeWasShown = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };
  listener.onHideNotice = () {
    noticeWasHidden = true;
  };
  listener.onShowNotice = () {
    noticeWasShown = true;
  };

  group("Show Notice", () {
    testWidgets("Reset SDK for bulk action", (WidgetTester tester) async {
      try {
        DidomiSdk.reset();
      } catch (ignored) {}

      isError = false;
      isReady = false;
      noticeWasHidden = false;
      noticeWasShown = false;

      DidomiSdk.addEventListener(listener);

      assert(isError == false);
      assert(isReady == false);
      assert(noticeWasHidden == false);
      assert(noticeWasShown == false);
    });

    testWidgets("Show Notice without initialization", (WidgetTester tester) async {
      // Start noticeApp
      noticeApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);
      assert(noticeWasHidden == false);
      assert(noticeWasShown == false);

      await tester.tap(showNoticeBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.key.toString().contains("showNotice") &&
              widget.data
                      ?.contains("Native message: Failed: \'An error occurred: Didomi SDK is not ready. Use the onReady callback to access this method.\'.") ==
                  true,
        ),
        findsOneWidget,
      );

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      // Check for NO dialog
      assert(noticeWasHidden == false);
      assert(noticeWasShown == false);
    });

    testWidgets("Initialize for following scenarios", (WidgetTester tester) async {
      // Start noticeApp
      noticeApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);
      assert(noticeWasHidden == false);
      assert(noticeWasShown == false);

      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);
      assert(noticeWasHidden == false);
      assert(noticeWasShown == false);
    });

    testWidgets("Show Notice with initialization", (WidgetTester tester) async {
      // Start noticeApp
      noticeApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);
      assert(noticeWasHidden == false);
      assert(noticeWasShown == false);

      await tester.tap(showNoticeBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("showNotice") && widget.data?.contains("Native message: OK") == true,
        ),
        findsOneWidget,
      );

      // Check for dialog
      assert(isError == false);
      assert(isReady == true);
      assert(noticeWasHidden == false);
      assert(noticeWasShown == true);
    });

    testWidgets("Show Notice with initialization then close it", (WidgetTester tester) async {
      // Start noticeApp
      noticeApp.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);
      assert(noticeWasHidden == false);
      assert(noticeWasShown == true);

      await tester.tap(hideNoticeCbFinder);
      await tester.pumpAndSettle();

      await tester.tap(showNoticeBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Text && widget.key.toString().contains("showNotice") && widget.data?.contains("Native message: OK") == true,
        ),
        findsOneWidget,
      );

      // Check for dialog
      assert(isError == false);
      assert(isReady == true);
      assert(noticeWasHidden == false);
      assert(noticeWasShown == true);

      await Future.delayed(Duration(seconds: 4));

      // Check for dialog
      assert(isError == false);
      assert(isReady == true);
      assert(noticeWasHidden == true);
      assert(noticeWasShown == true);
    });
  });
}
