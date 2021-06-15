import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/extensions/list.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getEnabledPurposeIds
class GetEnabledPurposeIds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetEnabledPurposeIdsState();
}

class _GetEnabledPurposeIdsState extends BaseSampleWidgetState<GetEnabledPurposeIds> {
  @override
  String getButtonName() => "GetEnabledPurposeIds";

  @override
  String getActionId() => "getEnabledPurposeIds";

  @override
  Future<String> callDidomiPlugin() async {
    final List<String> result = await DidomiSdk.enabledPurposeIds;
    result.sort(); // Required for UI tests
    if (result.isEmpty) {
      return "Enabled Purpose list is empty.";
    } else {
      return "Enabled Purposes: ${result.joinToString()}.";
    }
  }
}
