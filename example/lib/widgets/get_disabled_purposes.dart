import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getDisabledPurposes
class GetDisabledPurposes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetDisabledPurposesState();
}

class _GetDisabledPurposesState
    extends BaseSampleWidgetState<GetDisabledPurposes> {
  @override
  String getButtonName() => 'GetDisabledPurposes';

  @override
  String getActionId() => 'getDisabledPurposes';

  @override
  Future<String> callDidomiPlugin() async {
    final List<Purpose> result = await DidomiSdk.disabledPurposes;
    result.sort(); // Required for UI tests

    final String printable = result.map((purpose) => purpose.name).join(", ");
    print(printable);

    if (result.isEmpty) {
      return "Disabled Purpose list is empty.";
    } else {
      return "Disabled Purposes: $printable.";
    }
  }
}
