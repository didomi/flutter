import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/current_user_status.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getCurrentUserStatus and display purposes from result
class GetCurrentUserStatusPurposes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetCurrentUserStatusPurposesState();
}

class _GetCurrentUserStatusPurposesState extends BaseSampleWidgetState<GetCurrentUserStatusPurposes> {
  @override
  String getButtonName() => "GetCurrentUserStatusPurposes";

  @override
  String getActionId() => "getCurrentUserStatusPurposes";

  @override
  Future<String> callDidomiPlugin() async {
    final CurrentUserStatus status = await DidomiSdk.currentUserStatus;
    String result = "";
    status.purposes?.forEach((key, value) {
      result += "Key: $key, Id: ${value.id}, Enabled: ${value.enabled}\n";
    });
    return "Purposes: $result";
  }
}
