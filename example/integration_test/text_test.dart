import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_text_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final getTextBtnFinder = find.byKey(Key("getText"));
  final getWebviewStringsBtnFinder = find.byKey(Key("getWebviewStrings"));

  // Messages
  const expectedResult = "Native message: fr =>Avec votre consentement, nous et <a href=\"javascript:Didomi.preferences.show('vendors')\">nos partenaires</a> "
      "utilisons l'espace de stockage du terminal pour stocker et accéder à des données personnelles telles que des données de géolocalisation "
      "précises et d'identification par analyse du terminal. Nous traitons ces données à des fins telles que les publicités et contenus personnalisés, "
      "la mesure de performance des publicités et du contenu, les données d'audience et le développement des produits. Vous pouvez à tout moment retirer "
      "votre consentement ou vous opposer au traitement des données sur la base de l'intérêt légitime depuis le menu de l'application.en =>With your "
      "agreement, we and <a href=\"javascript:Didomi.preferences.show('vendors')\">our partners</a> use device storage to store and access personal data "
      "like precise geolocation data, and identification through device scanning. We process that data for purposes like personalised ads and content, "
      "ad and content measurement, audience insights and product development. You can withdraw your consent or object to data processing based on "
      "legitimate interest at any time from the app menu.";

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

    testWidgets("Get Text after initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder);

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

      assert(isError == false);
      assert(isReady == true);

      expect(find.byType(AlertDialog), findsNothing);

      await tester.tap(getWebviewStringsBtnFinder);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
