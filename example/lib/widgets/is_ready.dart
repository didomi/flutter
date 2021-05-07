import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.isReady
class IsReady extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IsReadyState();
  }
}

class _IsReadyState extends BaseSampleWidgetState<IsReady> {

  @override
  String getButtonName() {
    return 'Is SDK ready?';
  }

  @override
  String getActionId() {
    return 'isReady';
  }

  @override
  Future<String> callDidomiPlugin() async {
    final bool result = await DidomiSdk.isReady;
    return 'Result = $result';
  }
}