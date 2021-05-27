import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/log_level.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.setLogLevel
class SetLogLevel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowSetLogLevelState();
}

class _ShowSetLogLevelState extends BaseSampleWidgetState<SetLogLevel> {
  @override
  String getButtonName() => "Set Log Level (error)";

  @override
  String getActionId() => "setLogLevel";

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.setLogLevel(LogLevel.error);
    return "Level is error (${LogLevel.error.platformLevel}).";
  }
}
