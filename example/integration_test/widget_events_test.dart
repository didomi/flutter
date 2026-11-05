import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk/events/show_widget_event.dart';
import 'package:didomi_sdk/events/widget_custom_action_event.dart';
import 'package:didomi_sdk/events/widget_switch_layer_event.dart';
import 'package:didomi_sdk_example/testapps/sample_for_notice_tests.dart' as app;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/initialize_helper.dart';

/// Coverage note:
///
/// onShowWidget / onHideWidget / onWidgetSwitchLayer / onWidgetCustomAction are emitted by the Web SDK from inside a
/// WebView-rendered experience. The notice served by this example app's
/// configuration is natively rendered and contains no widget, so real widget
/// event delivery is not produced here: it is covered by widget_api_test.dart,
/// which initializes the SDK with a configuration containing widgets.
/// onWidgetSwitchLayer and onWidgetCustomAction require navigating between
/// layers or clicking a custom action button inside the widget WebView, which
/// is not automated here.
///
/// This test therefore covers what is verifiable automatically:
///  - the new listener fields exist, are assignable and are accepted by
///    addEventListener;
///  - registering them does not disturb the normal event flow (onReady still
///    fires, no error is reported);
///  - no widget event is spuriously emitted against a non-widget config, which
///    would indicate a wire-string or dispatch mistake;
///  - both native handlers still build and register — a missing Kotlin override
///    or a Swift typo regresses here.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final initializeBtnFinder = find.byKey(Key("initializeSmall"));
  final setupUIBtnFinder = find.byKey(Key("setupUI"));
  final showNoticeBtnFinder = find.byKey(Key("showNotice"));

  bool isError = false;
  bool isReady = false;
  bool widgetWasShown = false;
  bool widgetWasHidden = false;
  ShowWidgetEvent? lastShowWidgetEvent;
  WidgetSwitchLayerEvent? lastWidgetSwitchLayerEvent;
  WidgetCustomActionEvent? lastWidgetCustomActionEvent;

  final listener = EventListener();
  listener.onError = (String message) {
    isError = true;
  };
  listener.onReady = () {
    isReady = true;
  };
  listener.onShowWidget = (ShowWidgetEvent event) {
    widgetWasShown = true;
    lastShowWidgetEvent = event;
  };
  listener.onHideWidget = () {
    widgetWasHidden = true;
  };
  listener.onWidgetSwitchLayer = (WidgetSwitchLayerEvent event) {
    lastWidgetSwitchLayerEvent = event;
  };
  listener.onWidgetCustomAction = (WidgetCustomActionEvent event) {
    lastWidgetCustomActionEvent = event;
  };

  DidomiSdk.addEventListener(listener);

  group("Widget events", () {
    testWidgets("No widget event before initialization", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      assert(isError == false);
      assert(isReady == false);
      assert(widgetWasShown == false);
      assert(widgetWasHidden == false);
      assert(lastShowWidgetEvent == null);
      assert(lastWidgetSwitchLayerEvent == null);
      assert(lastWidgetCustomActionEvent == null);
    });

    testWidgets("Widget event listeners do not disrupt the event flow", (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      await InitializeHelper.initialize(tester, initializeBtnFinder, isReady: () => isReady);

      assert(isError == false);
      assert(isReady == true);

      if (Platform.isIOS) {
        await tester.tap(setupUIBtnFinder);
        await tester.pumpAndSettle();
      }

      await tester.tap(showNoticeBtnFinder);
      await tester.pumpAndSettle();

      // Events coming from the native SDK are not flushed by pumpAndSettle.
      await Future.delayed(Duration(seconds: 1));

      // The notice served by this config is native and holds no widget,
      // so no widget event must have been emitted.
      assert(isError == false);
      assert(widgetWasShown == false);
      assert(widgetWasHidden == false);
      assert(lastShowWidgetEvent == null);
      assert(lastWidgetSwitchLayerEvent == null);
      assert(lastWidgetCustomActionEvent == null);
    });
  });
}
