import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/current_user_status.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getCurrentUserStatus and display other info from result
class GetCurrentUserStatusOtherInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetCurrentUserStatusOtherInfoState();
}

class _GetCurrentUserStatusOtherInfoState extends BaseSampleWidgetState<GetCurrentUserStatusOtherInfo> {
  @override
  String getButtonName() => "GetCurrentUserStatusOtherInfo";

  @override
  String getActionId() => "getCurrentUserStatusOtherInfo";

  @override
  Future<String> callDidomiPlugin() async {
    final CurrentUserStatus result = await DidomiSdk.currentUserStatus;
    return "Other info in status: \n"
        "- User id ${result.userId}\n"
        "- Created ${result.created}\n"
        "- Updated ${result.updated}\n"
        "- Additional consent: ${result.additionalConsent}\n"
        "- Consent String: ${result.consentString}\n"
        "- DCS: ${result.didomiDcs}\n"
        "- Regulation: ${result.regulation}";
  }
}
