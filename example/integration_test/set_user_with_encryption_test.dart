
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk/events/sync_ready_event.dart';
import 'package:didomi_sdk_example/testapps/sample_for_set_user_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final setUserAuthWithEncryption = find.byKey(Key("setUserAuthWithEncryption"));
  final withExpiration = find.byKey(Key("setUserWithExpiration"));
  final withSetupUI = find.byKey(Key("setUserAndSetupUI"));
  final withDcsUsers = find.byKey(Key("withDcsUser"));
  final withSynchronizedUsers = find.byKey(Key("withSynchronizedUsers"));
  final underageFinder = find.byKey(Key("isUnderage"));
  final submitSetUser = find.byKey(Key("setUser"));
  final reset = find.byKey(Key("reset"));
  final listKey = Key("components_list");

  String? syncDoneUserId;
  bool isReady = false;
  bool syncError = false;
  bool consentChanged = false;
  SyncReadyEvent? syncReadyEvent;

  final listener = EventListener();
  listener.onReady = () {
    isReady = true;
  };
  listener.onConsentChanged = () {
    syncDoneUserId = null;
    syncError = false;
    consentChanged = true;
    syncReadyEvent = null;
  };
  listener.onSyncReady = (SyncReadyEvent event) {
    syncReadyEvent = event;
  };
  // ignore: deprecated_member_use
  listener.onSyncDone = (String userId) {
    syncDoneUserId = userId != "null" ? userId : null;
  };
  listener.onSyncError = (String error) {
    syncError = true;
    syncReadyEvent = null;
  };

  DidomiSdk.addEventListener(listener);

  Future waitForSync(WidgetTester tester) async {
    // Wait for sync result
    await tester.runAsync(() async {
      while (syncReadyEvent == null && !syncError) {
        await Future.delayed(Duration(milliseconds: 100));
      }
    });
  }

  // Reset all variables used for assertion.
  void resetExpectedSyncValues() {
    syncDoneUserId = null;
    syncError = false;
    consentChanged = false;
    syncReadyEvent = null;
  }

  // Assert that all the expected sync variables are empty.
  void assertExpectedSyncValuesAreEmpty() {
    assert(syncDoneUserId == null);
    assert(syncError == false);
    assert(syncReadyEvent == null);
  }

  /**
   * Note: Encryption parameters are NOT valid - sync will always fail
   */

  group("Set User with encryption", () {
    // Run before each test.
    setUp(() {
      syncReadyEvent = null;
    });

    /// Without initialization

    testWidgets("Click setUser with encryption without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(syncDoneUserId == null);
      assert(syncError == false);
      assert(syncReadyEvent == null);

      await tester.tap(setUserAuthWithEncryption);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      assertExpectedSyncValuesAreEmpty();
    });

    /// With initialization

    testWidgets("Click setUser with encryption and underage null", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "null")
      await tester.tap(find.text("null").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage false", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "false")
      await tester.tap(find.text("false").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage true", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    /// With setupUI

    testWidgets("Click setUser with encryption and underage null and setupUI", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "null")
      await tester.tap(find.text("null").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage false and setupUI", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "false")
      await tester.tap(find.text("false").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage true and setupUI", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    /// With DCS user

    testWidgets("Click setUser with encryption and underage null and DCS user", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "null")
      await tester.tap(find.text("null").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage false and DCS user", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "false")
      await tester.tap(find.text("false").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage true and DCS user", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    /// With DCS user ans SetupUI

    testWidgets("Click setUser with encryption and underage null and DCS user and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "null")
      await tester.tap(find.text("null").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage false and DCS user and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "false")
      await tester.tap(find.text("false").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage true and DCS user and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    /// With synchronized users

    testWidgets("Click setUser with encryption and underage null and Synchronized Users", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "null")
      await tester.tap(find.text("null").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage false and Synchronized Users", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "false")
      await tester.tap(find.text("false").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage true and Synchronized Users", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    /// With synchronized users and SetupUI

    testWidgets("Click setUser with encryption and underage null and Synchronized Users and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "null")
      await tester.tap(find.text("null").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage false and Synchronized Users and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "false")
      await tester.tap(find.text("false").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage true and Synchronized Users and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select withSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    /// With DCS user and synchronized users

    testWidgets("Click setUser with encryption and underage null and DCS user and Synchronized Users",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "null")
      await tester.tap(find.text("null").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage false and DCS user and Synchronized Users",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "false")
      await tester.tap(find.text("false").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage true and DCS user and Synchronized Users",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    /// With DCS user, synchronized users and SetupUI

    testWidgets("Click setUser with encryption and underage null and DCS user and Synchronized Users and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "null")
      await tester.tap(find.text("null").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select setUserAndSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage false and DCS user and Synchronized Users and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "false")
      await tester.tap(find.text("false").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select setUserAndSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });

    testWidgets("Click setUser with encryption and underage true and DCS user and Synchronized Users and setupUI",
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      if (!isReady) {
        // Initialize if not ready
        await InitializeHelper.initialize(tester, initializeBtnFinder);
      }

      resetExpectedSyncValues();

      // Reset
      await tester.tap(reset);
      await tester.pumpAndSettle();

      // Scroll DOWN
      await scrollDown(tester, listKey);

      // Open the dropdown
      await tester.tap(underageFinder);
      await tester.pumpAndSettle();

      // Select the desired option (assuming the option text is "true")
      await tester.tap(find.text("true").last);
      await tester.pumpAndSettle();

      // Scroll UP
      await scrollUp(tester, listKey);

      // Select withDcsUsers
      await tester.tap(withDcsUsers);

      // Select withSynchronizedUsers
      await tester.tap(withSynchronizedUsers);

      // Select setUserAndSetupUI
      await tester.tap(withSetupUI);

      // Select Encryption auth
      await tester.tap(setUserAuthWithEncryption);

      // Click on expiration so it becomes checked
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);

      resetExpectedSyncValues();

      // Uncheck expiration parameter
      await tester.tap(withExpiration);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // TODO Restore with correct user parameters : assertExpectedSyncValuesArePopulated();
      assert(syncError == true);
    });
  });
}
