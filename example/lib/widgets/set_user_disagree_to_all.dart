import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.setUserDisagreeToAll()
class SetUserDisagreeToAll extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetUserDisagreeToAll();
}

class _SetUserDisagreeToAll extends BaseSampleWidgetState<SetUserDisagreeToAll> {
  @override
  String getButtonName() => "Disagree to all";

  @override
  String getActionId() => "setUserDisagreeToAll";

  @override
  Future<String> callDidomiPlugin() async {
    final bool result = await DidomiSdk.setUserDisagreeToAll();
    return "Consent updated: $result.";
  }
}
