import 'package:didomi_sdk_example/events_helper.dart';
import 'package:flutter/material.dart';
import 'base_sample_widget_state.dart';

/// Widget displaying incoming SDK events
class SdkEventsLogger extends StatefulWidget {
  final String sdkEvents;
  final EventsHelper eventsHelper;

  SdkEventsLogger(this.sdkEvents, this.eventsHelper);

  @override
  State<StatefulWidget> createState() {
    return _SdkEventsLoggerState(sdkEvents, eventsHelper);
  }
}

class _SdkEventsLoggerState extends BaseSampleWidgetState<SdkEventsLogger> {
  String _sdkEvents = "";
  late bool _isListeningToVendorStatus;
  late EventsHelper _eventsHelper;

  @override
  bool get wantKeepAlive => false;

  _SdkEventsLoggerState(String sdkEvents, EventsHelper eventsHelper) {
    _sdkEvents = sdkEvents;
    _eventsHelper = eventsHelper;
    _isListeningToVendorStatus = eventsHelper.isListeningToVendorStatus;
  }

  @override
  List<Widget> buildWidgets() {
    return [
      ElevatedButton(
        child: Text(getButtonName(), textAlign: TextAlign.center),
        key: Key(getActionId()),
        onPressed: requestAction,
      ),
      Text('SDK Events:\n$_sdkEvents\n',
          key: Key("sdk_events_logger"))
    ];
  }

  @override
  Future<String> callDidomiPlugin() async {
    if (_isListeningToVendorStatus) {
      _eventsHelper.listenToEvents();
    } else {
      _eventsHelper.listenToVendorStatus("ipromote");
    }
    setState(() => _isListeningToVendorStatus = !_isListeningToVendorStatus);
    return ""; // Not used
  }

  @override
  String getActionId() {
    return "switch_listener_button";
  }

  @override
  String getButtonName() {
    return _isListeningToVendorStatus ? "Listen to events" : "Listen to vendor ipromote";
  }
}
