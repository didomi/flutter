import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk/events/show_widget_event.dart';
import 'package:didomi_sdk_example/testapps/sample_for_widget_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';

/// The SDK is initialized with a local configuration containing widgets (didomi_config_widgets.json),
/// so that tests don't depend on geolocation. The widget bundle is loaded from the network.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // The Web SDK and the widget bundle are loaded from the network, hence the extended timeout
  const widgetEventTimeout = Duration(seconds: 20);

  final initializeBtnFinder = find.byKey(Key("initializeWidgetNotice"));
  final showWidgetBtnFinder = find.byKey(Key("showWidget"));
  final hideWidgetBtnFinder = find.byKey(Key("hideWidget"));
  final isWidgetVisibleBtnFinder = find.byKey(Key("isWidgetVisible"));

  bool isError = false;
  bool isReady = false;
  ShowWidgetEvent? lastShowWidgetEvent;
  bool widgetWasHidden = false;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };
  listener.onShowWidget = (ShowWidgetEvent event) {
    lastShowWidgetEvent = event;
  };
  listener.onHideWidget = () {
    widgetWasHidden = true;
  };

  DidomiSdk.addEventListener(listener);

  /// Wait until [condition] is true, or fail after [widgetEventTimeout]
  Future<void> waitFor(WidgetTester tester, bool Function() condition, String reason) async {
    final startTime = DateTime.now();
    await tester.runAsync(() async {
      while (!condition() && DateTime.now().difference(startTime) < widgetEventTimeout) {
        await Future.delayed(Duration(milliseconds: 100));
      }
    });
    await tester.pumpAndSettle();
    expect(condition(), isTrue, reason: reason);
  }

  group("Widget APIs", () {
    testWidgets("Widget APIs before initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);

      await tester.tap(showWidgetBtnFinder);
      await tester.pumpAndSettle();
      assertNativeMessage("showWidget", notReadyMessage);

      await tester.tap(hideWidgetBtnFinder);
      await tester.pumpAndSettle();
      assertNativeMessage("hideWidget", notReadyMessage);

      await tester.tap(isWidgetVisibleBtnFinder);
      await tester.pumpAndSettle();
      assertNativeMessage("isWidgetVisible", notReadyMessage);

      assert(lastShowWidgetEvent == null);
      assert(widgetWasHidden == false);
    });

    testWidgets("Show widget", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder, isReady: () => isReady);
      assertNativeMessage("initializeWidgetNotice", okMessage);
      assert(isError == false);

      await tester.tap(isWidgetVisibleBtnFinder);
      await tester.pumpAndSettle();
      assertNativeMessage("isWidgetVisible", resultFalseMessage);

      // Show widget
      await tester.tap(showWidgetBtnFinder);
      await tester.pumpAndSettle();
      assertNativeMessage("showWidget", okMessage);

      await waitFor(tester, () => lastShowWidgetEvent != null, "onShowWidget event was not received");
      expect(lastShowWidgetEvent?.widgetId, "widget_cpra");
      assert(isError == false);
    });

    // With the current Android SDK, the Web SDK fails to notify the native SDK that the widget is shown
    // ("androidInterface.onWidgetShown is not a function"): isWidgetVisible returns false and hideWidget is ignored.
    // To be enabled on Android once the native SDK including the fix is released.
    testWidgets("Widget visibility and hide", (WidgetTester tester) async {
      // Start app: the SDK is still initialized and the widget displayed by the previous test is still visible
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(isWidgetVisibleBtnFinder);
      await tester.pumpAndSettle();
      assertNativeMessage("isWidgetVisible", resultTrueMessage);

      // Hide widget
      await tester.tap(hideWidgetBtnFinder);
      await tester.pumpAndSettle();
      assertNativeMessage("hideWidget", okMessage);

      await waitFor(tester, () => widgetWasHidden, "onHideWidget event was not received");

      await tester.tap(isWidgetVisibleBtnFinder);
      await tester.pumpAndSettle();
      assertNativeMessage("isWidgetVisible", resultFalseMessage);

      assert(isError == false);
    }, skip: Platform.isAndroid);
  });
}
