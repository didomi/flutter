import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

class _SetupUIState extends BaseSampleWidgetState<SetupUI> {

  @override
  String getButtonName() {
    return 'Setup UI';
  }

  @override
  String getActionId() {
    return 'setupUI';
  }

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.setupUI();
    return 'OK';
  }
}

class SetupUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SetupUIState();
  }
}