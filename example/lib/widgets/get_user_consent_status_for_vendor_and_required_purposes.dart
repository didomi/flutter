import 'dart:async';

import 'package:didomi_sdk/consent_status.dart';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getUserConsentStatusForVendorAndRequiredPurposes
class GetUserConsentStatusForVendorAndRequiredPurposes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserConsentStatusForVendorAndRequiredPurposesState();
}

class _GetUserConsentStatusForVendorAndRequiredPurposesState extends BaseSampleWidgetState<GetUserConsentStatusForVendorAndRequiredPurposes> {
  // Vendor id for sample
  final String vendorId = "738";  // Adbility Media

  @override
  String getButtonName() => "getUserConsentStatusForVendorAndRequiredPurposes\n$vendorId";

  @override
  String getActionId() => "getUserConsentStatusForVendorAndRequiredPurposes";

  @override
  Future<String> callDidomiPlugin() async {
    final ConsentStatus result = await DidomiSdk.getUserConsentStatusForVendorAndRequiredPurposes(vendorId);
    if (result.isUnknown) {
      return "No user status for vendor '$vendorId'.";
    } else {
      return "User status is '${result.string}' for vendor '$vendorId'.";
    }
  }
}
