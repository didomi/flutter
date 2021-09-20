import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/user_status.dart';
import 'package:didomi_sdk_example/extensions/list.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getDisabledPurposeIds
class GetUserStatusPurposes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserStatusPurposesState();
}

class _GetUserStatusPurposesState extends BaseSampleWidgetState<GetUserStatusPurposes> {
  @override
  String getButtonName() => "GetUserStatusPurposes";

  @override
  String getActionId() => "getUserStatusPurposes";

  @override
  Future<String> callDidomiPlugin() async {
    final UserStatus result = await DidomiSdk.userStatus;
    return "Enabled purposes: ${result.purposes?.global?.enabled?.joinToString() ?? "--"}";
  }
}
