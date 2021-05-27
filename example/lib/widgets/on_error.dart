import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.onError
class OnError extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnErrorState();
  }
}

class _OnErrorState extends BaseSampleWidgetState<OnError> {

  @override
  String getButtonName() {
    return 'Register OnError Callback';
  }

  @override
  String getActionId() {
    return 'onError';
  }

  @override
  Future<String> callDidomiPlugin() async {
    // Not used for this widget
    return '';
  }

  @override
  Future<void> requestAction() async {
    updateMessageFromNative("Waiting for onError callback");
    try {
      DidomiSdk.onError(() => updateMessageFromNative("SDK encountered an error"));
    } on PlatformException catch (e) {
      updateMessageFromNative("Failed: '${e.message}'.");
    }
  }
}
