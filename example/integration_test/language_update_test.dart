import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_language_update.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final languageCodeToUpdateFieldFinder = find.byKey(Key("languageCodeToUpdate"));
  final updateSelectedLanguageBtnFinder = find.byKey(Key("updateSelectedLanguage"));

  bool isError = false;
  bool isReady = false;
  String? selectedLanguageCode;
  String? failureReason;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };
  listener.onLanguageUpdated = (String languageCode) {
    selectedLanguageCode = languageCode;
  };
  listener.onLanguageUpdateFailed = (String reason) {
    failureReason = reason;
  };

  DidomiSdk.addEventListener(listener);

  group("LanguageUpdate", () {
    testWidgets("Update language before initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Tap on Update selected language
      await tester.tap(updateSelectedLanguageBtnFinder);
      await tester.pumpAndSettle();

      assert(selectedLanguageCode == null);
      assert(failureReason == null);

      assertNativeMessage("updateSelectedLanguage", notReadyMessage);
    });

    testWidgets("Update language after initialization returns error", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      // Initialize SDK
      await tester.tap(initializeBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 4));

      assert(isError == false);
      assert(isReady == true);

      assert(selectedLanguageCode == null);
      assert(failureReason == null);

      // Enter unavailable language
      await tester.enterText(languageCodeToUpdateFieldFinder, "zh-CN");
      await tester.pumpAndSettle();

      // Tap on Update selected language
      await tester.tap(updateSelectedLanguageBtnFinder);
      await tester.pumpAndSettle();

      assert(selectedLanguageCode == null);
      assert(failureReason == "Language code zh-CN is not enabled in the SDK");

      assertNativeMessage("updateSelectedLanguage", "Native message: OK");
    });

    testWidgets("Update language after initialization returns success", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == true);

      // Reset failure
      failureReason = null;

      assert(selectedLanguageCode == null);
      assert(failureReason == null);

      // Enter enabled language
      await tester.enterText(languageCodeToUpdateFieldFinder, "fr");
      await tester.pumpAndSettle();

      // Tap on Update selected language
      await tester.tap(updateSelectedLanguageBtnFinder);
      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 4));

      assert(selectedLanguageCode == "fr");
      assert(failureReason == null);

      assertNativeMessage("updateSelectedLanguage", "Native message: OK");
    });
  });
}
