import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/current_user_status.dart';
import 'package:didomi_sdk_example/testapps/sample_for_set_user_consent_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final agreeToAllBtnFinder = find.byKey(Key("setUserAgreeToAll"));
  final disagreeToAllBtnFinder = find.byKey(Key("setUserDisagreeToAll"));

  bool vendorStatusEnabled = false;

  DidomiSdk.addVendorStatusListener("ipromote", (VendorStatus vendorStatus) => {
    vendorStatusEnabled = vendorStatus.enabled
  });

  group("Listen to vendor status", () {
    testWidgets("Check callback when vendor is enabled and disabled", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(vendorStatusEnabled == false);

      await InitializeHelper.initialize(tester, initializeBtnFinder);

      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(vendorStatusEnabled == true);

      await tester.tap(disagreeToAllBtnFinder);
      await tester.pumpAndSettle();

      assert(vendorStatusEnabled == false);

      // Check removeVendorStatusListener
      DidomiSdk.removeVendorStatusListener("ipromote");

      await tester.tap(agreeToAllBtnFinder);
      await tester.pumpAndSettle();

      // Vendor status not updated
      assert(vendorStatusEnabled == false);
    });
  });
}
