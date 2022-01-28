import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/user_status.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getUserStatus and display additional info from result
class GetUserStatusOtherInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetUserStatusOtherInfo();
}

class _GetUserStatusOtherInfo extends BaseSampleWidgetState<GetUserStatusOtherInfo> {
  @override
  String getButtonName() => "GetUserStatusOtherInfo";

  @override
  String getActionId() => "getUserStatusOtherInfo";

  @override
  Future<String> callDidomiPlugin() async {
    final UserStatus result = await DidomiSdk.userStatus;
    return "Other info in status: \n"
        "- User id ${result.userId}\n"
        "- Created ${result.created}, updated ${result.updated}\n"
        "- Additional consent: ${result.additionalConsent}\n"
        "- Consent String ${result.consentString}";
  }
}
