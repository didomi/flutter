import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.onReady
class OnReady extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnReadyState();
  }
}

class _OnReadyState extends BaseSampleWidgetState<OnReady> {

  @override
  String getButtonName() {
    return 'Register OnReady Callback';
  }

  @override
  String getActionId() {
    return 'onReady';
  }

  @override
  Future<String> callDidomiPlugin() async {
    // Not used for this widget
    return '';
  }

  @override
  Future<void> requestAction() async {
    updateMessageFromNative("Waiting for onReady callback");
    try {
      DidomiSdk.onReady(() => updateMessageFromNative("SDK is ready!"));
    } on PlatformException catch (e) {
      updateMessageFromNative("Failed: '${e.message}'.");
    }
  }
}
