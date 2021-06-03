import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getEnabledPurposes
class GetEnabledPurposes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetEnabledPurposesState();
}

class _GetEnabledPurposesState
    extends BaseSampleWidgetState<GetEnabledPurposes> {
  @override
  String getButtonName() => "GetEnabledPurposes";

  @override
  String getActionId() => "getEnabledPurposes";

  @override
  Future<String> callDidomiPlugin() async {
    final List<Purpose> result = await DidomiSdk.enabledPurposes;
    result.sort(); // Required for UI tests

    final String printable = result.map((purpose) => purpose.name).join(", ");
    print(printable);

    if (result.isEmpty) {
      return "Enabled Purpose list is empty.";
    } else {
      return "Enabled Purposes: $printable.";
    }
  }
}
