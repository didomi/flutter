import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/testapps/sample_for_set_user_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String userId = "d13e49f6255c8729cbb201310f49d70d65f365415a67f034b567b7eac962b944eda131376594ef5e23b025fada4e4259e953ceb45ea57a2ced7872c567e6d1fae8dcc3a9772ead783d8513032e77d3fd";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final clearUser = find.byKey(Key("clearUser"));
  final setUserWithId = find.byKey(Key("setUserWithId"));
  final setUserAuthDeprecated = find.byKey(Key("setUserWithAuthDeprecated"));
  final setUserAuthWithHash = find.byKey(Key("setUserAuthWithHash"));
  final setUserAuthWithEncryption = find.byKey(Key("setUserAuthWithEncryption"));
  final setUserWithInvalidParams = find.byKey(Key("setUserWithInvalidParams"));
  final withSalt = find.byKey(Key("setUserWithSalt"));
  final withExpiration = find.byKey(Key("setUserWithExpiration"));
  final withSetupUI = find.byKey(Key("setUserAndSetupUI"));
  final submitSetUser = find.byKey(Key("setUser"));

  String? syncUserId;
  bool isReady = false;
  bool syncError = false;
  bool consentChanged = false;

  final listener = EventListener();
  listener.onReady = () {
    isReady = true;
  };
  listener.onConsentChanged = () {
    syncUserId = null;
    syncError = false;
    consentChanged = true;
  };
  listener.onSyncDone = (String userId) {
    syncUserId = userId != "null" ? userId : null;
  };
  listener.onSyncError = (String error) {
    syncError = true;
  };

  DidomiSdk.addEventListener(listener);

  Future waitForSync(WidgetTester tester) async {
    // Wait for sync result
    await tester.runAsync(() async {
      while (syncUserId == null && !syncError) {
        await Future.delayed(Duration(milliseconds: 100));
      }
    });
  }

  group("Set User", () {
    /// Without initialization

    testWidgets("Click setUser without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(syncUserId == null);
      assert(syncError == false);

      await tester.tap(setUserWithInvalidParams);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      assert(syncUserId == null);
      assert(syncError == false);
    });

    testWidgets("Click clearUser without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(syncUserId == null);
      assert(syncError == false);

      await tester.tap(clearUser);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      if (Platform.isIOS) {
        // iOS will trigger a log warning if the SDK is not initialized
        assertNativeMessage("setUser", okMessage);
      } else if (Platform.isAndroid) {
        // Android need the SDK to be initialized
        assertNativeMessage("setUser", notReadyMessage);
      }
      assert(syncUserId == null);
      assert(syncError == false);
    });

    /// With initialization

    testWidgets("initialize and call with error", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      await tester.tap(setUserWithInvalidParams);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // Encryption parameters are not valid
      assert(syncUserId == null);
      assert(syncError == true);
    });

    testWidgets("Click setUser with id", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      syncUserId = null;
      syncError = false;

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);
    });

    testWidgets("Click deprecated setUser", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      syncUserId = null;
      syncError = false;

      // Select with deprecated method
      await tester.tap(setUserAuthDeprecated);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);
    });

    testWidgets("Click setUser with encryption", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      syncUserId = null;
      syncError = false;

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);
      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);

      syncUserId = null;
      syncError = false;

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);
    });

    testWidgets("Click setUser with hash", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      syncUserId = null;
      syncError = false;

      // Click on expiration and salt so it becomes checked
      await tester.tap(setUserAuthWithHash);
      await tester.tap(withExpiration);
      await tester.tap(withSalt);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);

      syncUserId = null;
      syncError = false;

      // Uncheck salt parameter
      await tester.tap(withSalt);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assert(syncUserId == userId);
      assert(syncError == false);

      await waitForSync(tester);

      syncUserId = null;
      syncError = false;

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);
    });

    testWidgets("Click clearUser", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      syncUserId = null;
      syncError = false;
      consentChanged = false;

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);
      assert(consentChanged == false);

      // Clear user
      await tester.tap(clearUser);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", "Native message: OK");

      assert(syncUserId == null);
      assert(syncError == false);
      assert(consentChanged == true);
    });

    /// With setupUI

    testWidgets("Click setUser with id and setupUI", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      syncUserId = null;
      syncError = false;

      // Select with id
      await tester.tap(setUserWithId);
      // Select setUserAndSetupUI
      await tester.tap(withSetupUI);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);
    });

    testWidgets("Click setUser with encryption and setupUI", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      syncUserId = null;
      syncError = false;

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);
      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);

      syncUserId = null;
      syncError = false;

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);
    });

    testWidgets("Click setUser with hash and setupUI", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      syncUserId = null;
      syncError = false;

      // Click on expiration and salt so it becomes checked
      await tester.tap(setUserAuthWithHash);
      await tester.tap(withExpiration);
      await tester.tap(withSalt);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);

      syncUserId = null;
      syncError = false;

      // Uncheck salt parameter
      await tester.tap(withSalt);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assert(syncUserId == userId);
      assert(syncError == false);

      await waitForSync(tester);

      syncUserId = null;
      syncError = false;

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      assert(syncUserId == userId);
      assert(syncError == false);
    });
  });
}
