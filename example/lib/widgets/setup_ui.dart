import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.setupUI
class SetupUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetupUIState();
}

class _SetupUIState extends BaseSampleWidgetState<SetupUI> {
  @override
  String getButtonName() => "Setup UI";

  @override
  String getActionId() => "setupUI";

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.setupUI();
    return "OK";
  }
}
