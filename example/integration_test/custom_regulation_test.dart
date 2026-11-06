import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_custom_regulation_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initialize_helper.dart';

/// The SDK is initialized with a local configuration containing a regulation configuration
/// (didomi_config_custom_regulation.json), so that tests don't depend on geolocation.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeCustomRegulation"));

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

  group("Custom Regulation", () {
    testWidgets("Get applicable regulation and configuration with a regulation configuration", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initializeIfNeeded(tester, initializeBtnFinder, isReady: () => isReady);

      assert(isError == false);
      assert(isReady == true);

      final regulation = await DidomiSdk.applicableRegulation;
      assert(regulation == "custom");

      final configuration = await DidomiSdk.applicableRegulationConfiguration;
      assert(configuration != null);
      assert(configuration!.id == "abcd");
      assert(configuration!.versionId == "v1");
      assert(configuration!.numericalId == 123);
      assert(configuration!.regulationName == "gdpr");
      assert(configuration!.tokenStorageName == "didomi_token_abcd");
      assert(configuration!.mixed == false);
    });

    testWidgets("Get current user status with a regulation configuration", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initializeIfNeeded(tester, initializeBtnFinder, isReady: () => isReady);

      assert(isError == false);
      assert(isReady == true);

      final currentUserStatus = await DidomiSdk.currentUserStatus;
      // The regulation of the status is the regulation name of the configuration
      assert(currentUserStatus.regulation == "gdpr");
      assert(currentUserStatus.regulationConfiguration != null);
      assert(currentUserStatus.regulationConfiguration!.id == "abcd");
      assert(currentUserStatus.regulationConfiguration!.versionId == "v1");
      assert(currentUserStatus.regulationConfiguration!.numericalId == 123);
      assert(currentUserStatus.regulationConfiguration!.regulationName == "gdpr");
      assert(currentUserStatus.regulationConfiguration!.tokenStorageName == "didomi_token_abcd");
      assert(currentUserStatus.regulationConfiguration!.mixed == false);
    });
  });
}
