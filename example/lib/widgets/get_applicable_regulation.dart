import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/current_user_status.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getCurrentUserStatus and display other info from result
class GetApplicableRegulation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetApplicableRegulationState();
}

class _GetApplicableRegulationState extends BaseSampleWidgetState<GetApplicableRegulation> {
  @override
  String getButtonName() => "GetApplicableRegulation";

  @override
  String getActionId() => "getApplicableRegulation";

  @override
  Future<String> callDidomiPlugin() async {
    final String result = await DidomiSdk.applicableRegulation;
    return 'Result = $result';
  }
}
