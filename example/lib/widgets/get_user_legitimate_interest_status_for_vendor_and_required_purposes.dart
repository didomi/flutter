import 'dart:async';

import 'package:didomi_sdk/consent_status.dart';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getUserLegitimateInterestStatusForVendorAndRequiredPurposes
class GetUserLegitimateInterestStatusForVendorAndRequiredPurposes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserLegitimateInterestStatusForVendorAndRequiredPurposesState();
}

class _GetUserLegitimateInterestStatusForVendorAndRequiredPurposesState extends BaseSampleWidgetState<GetUserLegitimateInterestStatusForVendorAndRequiredPurposes> {
  // Vendor id for sample
  final String vendorId = "738";  // Adbility Media

  @override
  String getButtonName() => "getUserLegitimateInterestStatusForVendorAndRequiredPurposes\n$vendorId";

  @override
  String getActionId() => "getUserLegitimateInterestStatusForVendorAndRequiredPurposes";

  @override
  Future<String> callDidomiPlugin() async {
    final ConsentStatus result = await DidomiSdk.getUserLegitimateInterestStatusForVendorAndRequiredPurposes(vendorId);
    if (result.isUnknown) {
      return "No user status for vendor '$vendorId'.";
    } else {
      return "User status is '${result.string}' for vendor '$vendorId' and required purposes.";
    }
  }
}
