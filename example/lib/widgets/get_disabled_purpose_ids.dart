import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/extensions/list.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getDisabledPurposeIds
class GetDisabledPurposeIds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetDisabledPurposeIdsState();
}

class _GetDisabledPurposeIdsState extends BaseSampleWidgetState<GetDisabledPurposeIds> {
  @override
  String getButtonName() => "GetDisabledPurposeIds";

  @override
  String getActionId() => "getDisabledPurposeIds";

  @override
  Future<String> callDidomiPlugin() async {
    final List<String> result = await DidomiSdk.disabledPurposeIds;
    result.sort(); // Required for UI tests
    if (result.isEmpty) {
      return "Disabled Purpose list is empty.";
    } else {
      return "Disabled Purposes: ${result.joinToString()}.";
    }
  }
}
