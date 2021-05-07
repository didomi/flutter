import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.reset
class Reset extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetState();
  }
}

class _ResetState extends BaseSampleWidgetState<Reset> {

  @override
  String getButtonName() {
    return 'Reset consent';
  }

  @override
  String getActionId() {
    return 'reset';
  }

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.reset();
    return 'OK';
  }
}