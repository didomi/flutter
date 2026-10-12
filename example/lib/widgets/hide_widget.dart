import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.hideWidget
class HideWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HideWidgetState();
}

class _HideWidgetState extends BaseSampleWidgetState<HideWidget> {
  @override
  String getButtonName() => "Hide widget";

  @override
  String getActionId() => "hideWidget";

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.hideWidget();
    return "OK";
  }
}
