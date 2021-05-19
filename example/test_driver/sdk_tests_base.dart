import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  bool noticeDisplayed = false;
  bool noticeHidden = false;
  bool onReadyReceived = false;
  bool onErrorReceived = false;
  enableFlutterDriverExtension(handler: (command) async {
    switch (command) {
      case 'isNoticeDisplayed':
        return noticeDisplayed.toString();
      case 'isNoticeHidden':
        return noticeHidden.toString();
      case 'isOnReadyReceived':
        return onReadyReceived.toString();
      case 'isOnErrorReceived':
        return onErrorReceived.toString();
    }
    throw Exception('Unknown command');
  });

  EventListener listener = EventListener();
  listener.onShowNotice = () {
    noticeDisplayed = true;
    // Flutter UI tests can not interact with native components
    // so we hide notice just after it is displayed
    Future.delayed(const Duration(seconds: 1), () => DidomiSdk.hideNotice());
  };
  listener.onHideNotice = () {
    noticeHidden = true;
  };
  listener.onReady = () {
    onReadyReceived = true;
  };
  listener.onError = (msg) {
    onErrorReceived = true;
  };
  DidomiSdk.addEventListener(listener);
}