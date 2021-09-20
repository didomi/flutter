import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/user_status.dart';
import 'package:didomi_sdk_example/extensions/list.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getDisabledPurposeIds
class GetUserStatusVendors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserStatusVendorsState();
}

class _GetUserStatusVendorsState extends BaseSampleWidgetState<GetUserStatusVendors> {
  @override
  String getButtonName() => "GetUserStatusVendors";

  @override
  String getActionId() => "getUserStatusVendors";

  @override
  Future<String> callDidomiPlugin() async {
    final UserStatus result = await DidomiSdk.userStatus;
    return "Enabled vendors: ${result.vendors?.global?.enabled?.joinToString() ?? "--"}";
  }
}
