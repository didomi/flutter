import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.shouldConsentBeCollected
class CheckConsent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckConsentState();
  }
}

class _CheckConsentState extends BaseSampleWidgetState<CheckConsent> {

  @override
  String getButtonName() {
    return 'Should consent be collected?';
  }

  @override
  String getActionId() {
    return 'shoudConsentBeCollected';
  }

  @override
  Future<String> callDidomiPlugin() async {
    final bool result = await DidomiSdk.shouldConsentBeCollected;
    return 'Result = $result';
  }
}