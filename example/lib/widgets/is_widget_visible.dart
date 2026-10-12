import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.isWidgetVisible
class IsWidgetVisible extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IsWidgetVisibleState();
}

class _IsWidgetVisibleState extends BaseSampleWidgetState<IsWidgetVisible> {
  @override
  String getButtonName() => "Is widget visible?";

  @override
  String getActionId() => "isWidgetVisible";

  @override
  Future<String> callDidomiPlugin() async {
    final bool result = await DidomiSdk.isWidgetVisible();
    return "Result = $result";
  }
}
