import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/purpose.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getPurpose
class GetPurpose extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetPurposeState();
}

class _GetPurposeState
    extends BaseSampleWidgetState<GetPurpose> {
  @override
  String getButtonName() => 'GetPurpose';

  @override
  String getActionId() => 'getPurpose';

  @override
  Future<String> callDidomiPlugin() async {
    final Purpose result = await DidomiSdk.getPurpose("cookies");

    if (result == null) {
      return "Purpose does not exist.";
    } else {
      return "Purpose: ${result.name}.";
    }
  }
}
