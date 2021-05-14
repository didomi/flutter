// @dart=2.9

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:didomi_sdk_example/main.dart' as app;

void main() {

  bool noticeDisplayed = false;
  enableFlutterDriverExtension(handler: (command) async {
    switch (command) {
      case 'isNoticeDisplayed':
        return noticeDisplayed.toString();
    }
    throw Exception('Unknown command');
  });

  EventListener listener = EventListener();
  listener.onShowNotice = () {
    // Flutter UI tests can not interact with native components
    DidomiSdk.hideNotice();
    noticeDisplayed = true;
  };
  DidomiSdk.addEventListener(listener);

  app.main();
}
