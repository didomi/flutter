import 'dart:async';

import 'package:didomi_sdk/consent_status.dart';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.GetUserStatusForVendor
class GetUserStatusForVendor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserStatusForVendorState();
}

class _GetUserStatusForVendorState extends BaseSampleWidgetState<GetUserStatusForVendor> {
  // Vendor id for sample
  final String vendorId = "1111";  // 152 Media LLC

  @override
  String getButtonName() => "GetUserStatusForVendor\n$vendorId";

  @override
  String getActionId() => "getUserStatusForVendor";

  @override
  Future<String> callDidomiPlugin() async {
    final ConsentStatus result = await DidomiSdk.getUserStatusForVendor(vendorId);
    if (result.isUnknown) {
      return "No user status for vendor '$vendorId'.";
    } else {
      return "User status is '${result.string}' for vendor '$vendorId'.";
    }
  }
}
