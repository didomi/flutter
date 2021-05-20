import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.SetUserStatus()
class SetUserStatus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetUserStatus();
}

class _SetUserStatus extends BaseSampleWidgetState<SetUserStatus> {
  @override
  String getButtonName() => "Set User Status (LI only)";

  @override
  String getActionId() => "setUserStatus";

  @override
  Future<String> callDidomiPlugin() async {
    final bool result = await DidomiSdk.setUserStatus(false, true, false, true);
    return "Consent updated: $result.";
  }
}
