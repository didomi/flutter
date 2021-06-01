import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/test/sample_for_translated_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final updateSelectedLanguageBtnFinder = find.byKey(Key("updateSelectedLanguage"));
  final getTranslatedTextBtnFinder = find.byKey(Key("getTranslatedText"));
  final languageCodeToUpdateFieldFinder = find.byKey(Key("languageCodeToUpdate"));

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

  group("Locale Test", () {
    testWidgets("Get Translated Text before initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(getTranslatedTextBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getTranslatedText") &&
              widget.data?.contains("Native message: Failed: \'Didomi SDK is not ready. Use the onReady callback to access this method.\'.") == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets("Get Translated Texts after initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      assert(isError == false);
      assert(isReady == true);

      // Tap on log level button
      await tester.tap(getTranslatedTextBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getTranslatedText") &&
              widget.data?.startsWith("Native message: With your agreement, we") == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets("Get Translated Texts after invalid language update", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(languageCodeToUpdateFieldFinder);
      await tester.pumpAndSettle();

      await tester.enterText(languageCodeToUpdateFieldFinder, "zh_CN");
      await tester.pumpAndSettle();

      await tester.tap(updateSelectedLanguageBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(getTranslatedTextBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getTranslatedText") &&
              widget.data?.startsWith("Native message: With your agreement, we") == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets("Get Translated Texts after valid language update", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(languageCodeToUpdateFieldFinder);
      await tester.pumpAndSettle();

      await tester.enterText(languageCodeToUpdateFieldFinder, "fr");
      await tester.pumpAndSettle();

      await tester.tap(updateSelectedLanguageBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(getTranslatedTextBtnFinder);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
              (Widget widget) =>
          widget is Text &&
              widget.key.toString().contains("getTranslatedText") &&
              widget.data?.startsWith("Native message: Avec votre consentement, nous") == true,
        ),
        findsOneWidget,
      );
    });
  });
}
