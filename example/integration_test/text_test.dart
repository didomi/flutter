import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_text_tests.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Messages
  const expectedConsentEn = "Native message: With your agreement, we";
  const expectedConsentFr = "Native message: Avec votre consentement, nous";
  const expectedResult = "Native message: fr =>Avec votre consentement, nous et <a "
      "href=\"javascript:Didomi.preferences.show('vendors')\">nos partenaires</a> utilisons l'espace de "
      "stockage du terminal pour stocker, et accéder à, <stack id=\"1\">des données personnelles telles que "
      "des données de géolocalisation précises et d'identification par analyse du terminal.</stack><br "
      "/>Nous traitons ces données à des fins telles que <stack id=\"42\">les publicités et contenus "
      "personnalisés, la mesure de performance des publicités et du contenu, les données d'audience et le "
      "développement des produits.</stack><br />Vous pouvez à tout moment retirer votre consentement ou "
      "vous opposer au traitement des données sur la base de l'intérêt légitime en consultant la rubrique « "
      "Préférences de consentement » dans le menu de cette application.en =>With your agreement, we and <a "
      "href=\"javascript:Didomi.preferences.show('vendors')\">our partners</a> use device storage to store "
      "and access personal data like <stack id=\"1\">precise geolocation data, and identification through "
      "device scanning</stack>.<br />We process that data for purposes like <stack id=\"42\">personalised ads "
      "and content, ad and content measurement, audience insights and product development</stack>.<br />You "
      "can withdraw your consent or object to data processing based on legitimate interest at any time by "
      "going to \"Consent Preferences\" in the menu of this app.";
  const expectedJavascript = "window.didomiOnReady = window.didomiOnReady ||\n[];window.didomiOnReady.push(function (Didomi)\n{Didomi.notice.hide();"
      "Didomi.setUserStatus({\"purposes\":{\"consent\":{\"enabled\":[],\"disabled\":[]},\"legitimate_interest\":{\"enabled\":[],\"disabled\":[]}},"
      "\"vendors\":{\"consent\":{\"enabled\":[],\"disabled\":[]},\"legitimate_interest\":{\"enabled\":[],\"disabled\":[]}},"
      "\"user_id\":\"48d64935-942a-4ee2-b2d4-8de517969728\",\"created\":\"\d+-\d+-\d+T\d+:\d+:\d+Z\",\"updated\":\"\d+-\d+-\d+T\d+:\d+:\d+Z\","
      "\"source\":{\"type\":\"app\",\"domain\":\"io.didomi.flutter.sample\"},\"action\":\"webview\"});});";
  const expectedQueryString = "didomiConfig.user.externalConsent.value=";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final getTextBtnFinder = find.byKey(Key("getText"));
  final getWebviewStringsBtnFinder = find.byKey(Key("getWebviewStrings"));
  final updateSelectedLanguageBtnFinder = find.byKey(Key("updateSelectedLanguage"));
  final getTranslatedTextBtnFinder = find.byKey(Key("getTranslatedText"));
  final languageCodeToUpdateFieldFinder = find.byKey(Key("languageCodeToUpdate"));
  final listKey = Key("components_list");

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

  group("Text Test", () {
    testWidgets("Get Text before initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(getTextBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getText", notReadyMessage);
    });

    testWidgets("Get webView string before initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      expect(find.byType(AlertDialog), findsNothing);

      await tester.tap(getWebviewStringsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getWebviewStrings", notReadyMessage);

      expect(find.byType(AlertDialog), findsNothing);

      assert(isError == false);
      assert(isReady == false);
    });

    testWidgets("Get Translated Text before initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await scrollDown(tester, listKey);

      await tester.tap(getTranslatedTextBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getTranslatedText", notReadyMessage);
    });

    testWidgets("Get Text after initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await tester.tap(getTextBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getText", expectedResult);
    });

    testWidgets("Get webView string after initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      expect(find.byType(AlertDialog), findsNothing);

      await tester.tap(getWebviewStringsBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessage("getWebviewStrings", defaultMessage);

      expect(find.byType(AlertDialog), findsOneWidget);

      final javascriptResult = await DidomiSdk.javaScriptForWebView;
      final exp = RegExp(expectedJavascript);
      assert(exp.hasMatch(expectedJavascript), "Actual: $javascriptResult\nExpected: $expectedJavascript");

      final queryStringResult = await DidomiSdk.queryStringForWebView;
      assert(queryStringResult.startsWith(expectedQueryString), "Actual: $queryStringResult\nExpected: $expectedQueryString");
    });

    testWidgets("Get Translated Texts after initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);

      // Tap on log level button
      await tester.tap(getTranslatedTextBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessageStartsWith("getTranslatedText", expectedConsentEn);
    });

    testWidgets("Get Translated Texts after invalid language update", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);

      await tester.tap(languageCodeToUpdateFieldFinder);
      await tester.pumpAndSettle();

      await tester.enterText(languageCodeToUpdateFieldFinder, "zh_CN");
      await tester.pumpAndSettle();

      await tester.tap(updateSelectedLanguageBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(getTranslatedTextBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessageStartsWith("getTranslatedText", expectedConsentEn);
    });

    testWidgets("Get Translated Texts after valid language update", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      assert(isError == false);
      assert(isReady == true);

      await scrollDown(tester, listKey);

      await tester.tap(languageCodeToUpdateFieldFinder);
      await tester.pumpAndSettle();

      await tester.enterText(languageCodeToUpdateFieldFinder, "fr");
      await tester.pumpAndSettle();

      await tester.tap(updateSelectedLanguageBtnFinder);
      await tester.pumpAndSettle();

      await tester.tap(getTranslatedTextBtnFinder);
      await tester.pumpAndSettle();

      assertNativeMessageStartsWith("getTranslatedText", expectedConsentFr);
    });
  });
}
