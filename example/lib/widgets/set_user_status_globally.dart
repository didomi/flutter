import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.SetUserStatusGlobally()
class SetUserStatusGlobally extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetUserStatusGloballyState();
}

class _SetUserStatusGloballyState extends BaseSampleWidgetState<SetUserStatusGlobally> {
  @override
  String getButtonName() => "Set User Status globally (LI only)";

  @override
  String getActionId() => "setUserStatusGlobally";

  @override
  Future<String> callDidomiPlugin() async {
    final bool result = await DidomiSdk.setUserStatusGlobally(false, true, false, true);
    return "Consent updated: $result.";
  }
}
