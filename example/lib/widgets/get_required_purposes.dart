import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getRequiredPurposes
class GetRequiredPurposes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetRequiredPurposesState();
}

class _GetRequiredPurposesState
    extends BaseSampleWidgetState<GetRequiredPurposes> {
  @override
  String getButtonName() => "GetRequiredPurposes";

  @override
  String getActionId() => "getRequiredPurposes";

  @override
  Future<String> callDidomiPlugin() async {
    final List<Purpose>? result = await DidomiSdk.requiredPurposes;
    result?.sort(); // Required for UI tests

    final String? printable = result?.map((purpose) => purpose.name).join(", ");
    print(printable);

    if (result == null || result.isEmpty) {
      return "Required Purpose list is empty.";
    } else {
      return "Required Purposes: $printable.";
    }
  }
}
