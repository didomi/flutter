import 'dart:async';

import 'package:didomi_sdk/consent_status.dart';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.GetUserConsentStatusForPurpose
class GetUserConsentStatusForPurpose extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserConsentStatusForPurpose();
}

class _GetUserConsentStatusForPurpose extends BaseSampleWidgetState<GetUserConsentStatusForPurpose> {
  // Purpose id for sample
  final String purposeId = "cookies";

  @override
  String getButtonName() => "GetUserConsentStatusForPurpose\nfor $purposeId";

  @override
  String getActionId() => "getUserConsentStatusForPurpose";

  @override
  Future<String> callDidomiPlugin() async {
    final ConsentStatus result = await DidomiSdk.getUserConsentStatusForPurpose(purposeId);
    if (result.isUnknown) {
      return "No user status for purpose '$purposeId'.";
    } else {
      return "User status is '${result.string}' for purpose '$purposeId'.";
    }
  }
}
