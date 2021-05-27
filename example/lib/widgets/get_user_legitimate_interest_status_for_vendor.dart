import 'dart:async';

import 'package:didomi_sdk/consent_status.dart';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.GetUserLegitimateInterestStatusForVendor
class GetUserLegitimateInterestStatusForVendor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserLegitimateInterestStatusForVendorState();
}

class _GetUserLegitimateInterestStatusForVendorState extends BaseSampleWidgetState<GetUserLegitimateInterestStatusForVendor> {
  // Vendor id for sample
  final String vendorId = "738";  // Adbility Media

  @override
  String getButtonName() => "GetUserLegitimateInterestStatusForVendor\n$vendorId";

  @override
  String getActionId() => "getUserLegitimateInterestStatusForVendor";

  @override
  Future<String> callDidomiPlugin() async {
    final ConsentStatus result = await DidomiSdk.getUserLegitimateInterestStatusForVendor(vendorId);
    if (result.isUnknown) {
      return "No user status for vendor '$vendorId'.";
    } else {
      return "User status is '${result.string}' for vendor '$vendorId'.";
    }
  }
}
