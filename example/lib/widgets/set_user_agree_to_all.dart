import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.setUserAgreeToAll()
class SetUserAgreeToAll extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetUserAgreeToAll();
}

class _SetUserAgreeToAll extends BaseSampleWidgetState<SetUserAgreeToAll> {
  @override
  String getButtonName() => "Agree to all";

  @override
  String getActionId() => "setUserAgreeToAll";

  @override
  Future<String> callDidomiPlugin() async {
    final bool result = await DidomiSdk.setUserAgreeToAll();
    return "Consent updated: $result.";
  }
}
