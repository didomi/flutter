import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/current_user_status.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getCurrentUserStatus and display vendors from result
class GetCurrentUserStatusVendors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetCurrentUserStatusVendorsState();
}

class _GetCurrentUserStatusVendorsState extends BaseSampleWidgetState<GetCurrentUserStatusVendors> {
  @override
  String getButtonName() => "GetCurrentUserStatusVendors";

  @override
  String getActionId() => "getCurrentUserStatusVendors";

  @override
  Future<String> callDidomiPlugin() async {
    final CurrentUserStatus status = await DidomiSdk.currentUserStatus;
    String result = "";
    status.vendors?.forEach((key, value) {
      result += "Key: $key, Id: ${value.id}, Enabled: ${value.enabled}\n";
    });
    return "Vendors: $result";
  }
}
