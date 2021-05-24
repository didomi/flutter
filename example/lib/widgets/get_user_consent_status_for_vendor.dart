import 'dart:async';

import 'package:didomi_sdk/consent_status.dart';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.GetUserConsentStatusForVendor
class GetUserConsentStatusForVendor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserConsentStatusForVendorState();
}

class _GetUserConsentStatusForVendorState extends BaseSampleWidgetState<GetUserConsentStatusForVendor> {
  // Vendor id for sample
  final String vendorId = "1";

  @override
  String getButtonName() => "GetUserConsentStatusForVendor\n$vendorId";

  @override
  String getActionId() => "getUserConsentStatusForVendor";

  @override
  Future<String> callDidomiPlugin() async {
    final ConsentStatus result = await DidomiSdk.getUserConsentStatusForVendor(vendorId);
    if (result.isUnknown) {
      return "No user status for vendor '$vendorId'.";
    } else {
      return "User status is '${result.string}' for vendor '$vendorId'.";
    }
  }
}
