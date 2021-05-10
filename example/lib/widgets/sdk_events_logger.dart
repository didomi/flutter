import 'package:didomi_sdk/events/event_listener.dart';
import 'package:flutter/material.dart';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget displaying incoming SDK events
class SdkEventsLogger extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SdkEventsLoggerState();
  }
}

class _SdkEventsLoggerState extends State<SdkEventsLogger> {

  String _sdkEvents = '';
  EventListener listener = EventListener();

  _SdkEventsLoggerState() {
    listener.onReady = () {
      onEvent("SDK Ready");
    };
    listener.onError = (message) {
      onEvent("Error : $message");
    };
    listener.onShowNotice = () {
      onEvent("Notice displayed");
    };
    listener.onHideNotice = () {
      onEvent("Notice hidden");
    };

    DidomiSdk.addEventListener(listener);
  }

  void onEvent(String eventDescription) {
    final snackBar = SnackBar(content: Text(eventDescription));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      _sdkEvents += "\n- $eventDescription";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('SDK Events:\n$_sdkEvents\n');
  }

  @override
  void dispose() {
    super.dispose();
    DidomiSdk.removeEventListener(listener);
  }
}