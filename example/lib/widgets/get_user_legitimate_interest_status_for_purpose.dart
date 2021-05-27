import 'dart:async';

import 'package:didomi_sdk/consent_status.dart';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.GetUserLegitimateInterestStatusForPurpose
class GetUserLegitimateInterestStatusForPurpose extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserLegitimateInterestStatusForPurposeState();
}

class _GetUserLegitimateInterestStatusForPurposeState extends BaseSampleWidgetState<GetUserLegitimateInterestStatusForPurpose> {
  // Purpose id for sample
  final String purposeId = "cookies";

  @override
  String getButtonName() => "GetUserLegitimateInterestStatusForPurpose\n$purposeId";

  @override
  String getActionId() => "getUserLegitimateInterestStatusForPurpose";

  @override
  Future<String> callDidomiPlugin() async {
    final ConsentStatus result = await DidomiSdk.getUserLegitimateInterestStatusForPurpose(purposeId);
    if (result.isUnknown) {
      return "No user status for purpose '$purposeId'.";
    } else {
      return "User status is '${result.string}' for purpose '$purposeId'.";
    }
  }
}
