import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk/events/sync_ready_event.dart';
import 'package:didomi_sdk_example/testapps/sample_for_set_user_tests.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const String userId =
      "d13e49f6255c8729cbb201310f49d70d65f365415a67f034b567b7eac962b944eda131376594ef5e23b025fada4e4259e953ceb45ea57a2ced7872c567e6d1fae8dcc3a9772ead783d8513032e77d3fd";

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final clearUser = find.byKey(Key("clearUser"));
  final setUserWithId = find.byKey(Key("setUserWithId"));
  final setUserWithInvalidParams = find.byKey(Key("setUserWithInvalidParams"));
  final withSetupUI = find.byKey(Key("setUserAndSetupUI"));
  final underageFinder = find.byKey(Key("isUnderage"));
  final submitSetUser = find.byKey(Key("setUser"));
  final reset = find.byKey(Key("reset"));
  final listKey = Key("components_list");

  String? syncDoneUserId;
  bool isReady = false;
  bool syncError = false;
  SyncReadyEvent? syncReadyEvent;

  final listener = EventListener();
  listener.onReady = () {
    isReady = true;
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

  // Assert sync event is triggered correctly.
  Future<void> assertSyncReadyEvent(WidgetTester tester) async {
    // First time the sync event is triggered. Status is applied and API Event not triggered.
    assert(syncReadyEvent?.statusApplied == true);
    assert((await syncReadyEvent?.syncAcknowledged()) == false);
    assert((await syncReadyEvent?.syncAcknowledged()) == false);
    assert(syncReadyEvent?.organizationUserId == userId);

    // We reinitialize the SDK to re-trigger the sync event.
    await tester.tap(initializeBtnFinder);
    await tester.pumpAndSettle();
    await waitForSync(tester);

    // Second time the sync event is triggered. Status is not applied and API Event not triggered.
    assert(syncReadyEvent?.statusApplied == false);
    assert((await syncReadyEvent?.syncAcknowledged()) == false);
    assert((await syncReadyEvent?.syncAcknowledged()) == false);
    assert(syncReadyEvent?.organizationUserId == userId);
  }

  // Reset all variables used for assertion.
  void resetExpectedSyncValues() {
    syncDoneUserId = null;
    syncError = false;
    syncReadyEvent = null;
  }

  // Assert that all the expected sync variables are populated.
  void assertExpectedSyncValuesArePopulated() {
    assert(syncDoneUserId == userId);
    assert(syncError == false);
    assert(syncReadyEvent != null);
    assert(syncReadyEvent?.organizationUserId == userId);
  }

  // Assert that all the expected sync variables are empty.
  void assertExpectedSyncValuesAreEmpty() {
    assert(syncDoneUserId == null);
    assert(syncError == false);
    assert(syncReadyEvent == null);
  }

  group("Set User with OUID only", () {
    // Run before each test.
    setUp(() {
      syncReadyEvent = null;
    });

    /// Without initialization

    testWidgets("Click setUser without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(syncDoneUserId == null);
      assert(syncError == false);
      assert(syncReadyEvent == null);

      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      assertExpectedSyncValuesAreEmpty();
    });

    testWidgets("Click clearUser without initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assertExpectedSyncValuesAreEmpty();

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
      assertExpectedSyncValuesAreEmpty();
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

      // Clear user for bulk tests
      await tester.tap(clearUser);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      resetExpectedSyncValues();

      // Set user with invalid parameters
      await tester.tap(setUserWithInvalidParams);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      await waitForSync(tester);

      // Encryption parameters are not valid
      assert(syncDoneUserId == null);
      assert(syncError == true);
      assert(syncReadyEvent == null);
    });

    testWidgets("Click setUser with id with underage null", (WidgetTester tester) async {
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

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assert(syncDoneUserId == userId);
      assert(syncError == false);

      await assertSyncReadyEvent(tester);
    });

    testWidgets("Click setUser with id and underage false", (WidgetTester tester) async {
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

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assert(syncDoneUserId == userId);
      assert(syncError == false);

      await assertSyncReadyEvent(tester);
    });

    testWidgets("Click setUser with id and underage true", (WidgetTester tester) async {
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

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assert(syncDoneUserId == userId);
      assert(syncError == false);

      await assertSyncReadyEvent(tester);
    });

    testWidgets("Click clearUser", (WidgetTester tester) async {
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

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assertExpectedSyncValuesArePopulated();

      // Clear user
      await tester.tap(clearUser);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      assertExpectedSyncValuesArePopulated();
    });

    /// With setupUI

    testWidgets("Click setUser with id and underage null and setupUI", (WidgetTester tester) async {
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

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assertExpectedSyncValuesArePopulated();
    });

    testWidgets("Click setUser with id and underage false and setupUI", (WidgetTester tester) async {
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

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assertExpectedSyncValuesArePopulated();
    });

    testWidgets("Click setUser with id and underage true and setupUI", (WidgetTester tester) async {
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

      // Select with id
      await tester.tap(setUserWithId);
      await tester.tap(submitSetUser);
      await tester.pumpAndSettle();

      assertNativeMessage("setUser", okMessage);

      await waitForSync(tester);

      assertExpectedSyncValuesArePopulated();
    });
  });
}
