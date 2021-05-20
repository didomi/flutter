import 'package:flutter/material.dart';
import 'base_sample_widget_state.dart';

/// Widget displaying incoming SDK events
class SdkEventsLogger extends StatefulWidget {
  final String sdkEvents;

  SdkEventsLogger(this.sdkEvents);

  @override
  State<StatefulWidget> createState() {
    return _SdkEventsLoggerState(sdkEvents);
  }
}

class _SdkEventsLoggerState extends BaseSampleWidgetState<SdkEventsLogger> {
  String _sdkEvents = "";

  @override
  bool get wantKeepAlive => false;

  _SdkEventsLoggerState(String sdkEvents) {
    _sdkEvents = sdkEvents;
  }

  @override
  List<Widget> buildWidgets() {
    return [
      Text('SDK Events:\n$_sdkEvents\n',
          key: Key("sdk_events_logger"))
    ];
  }

  @override
  Future<String> callDidomiPlugin() async {
    return ""; // Not used
  }

  @override
  String getActionId() {
    return ""; // Not used
  }

  @override
  String getButtonName() {
    return ""; // Not used
  }
}
