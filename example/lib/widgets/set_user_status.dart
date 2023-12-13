import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.SetUserStatus()
class SetUserStatus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetUserStatusState();
}

class _SetUserStatusState extends BaseSampleWidgetState<SetUserStatus> {

  final String vendor1 = "1111"; // 152 Media LLC
  final String vendor2 = "217"; // 2K Direct, Inc
  final String vendor3 = "318"; // A.Mob

  final String purpose1 = "cookies";
  final String purpose2 = "advertising_personalization";
  final String purpose3 = "ad_delivery";


  @override
  String getButtonName() => "Set User Status (detailed)";

  @override
  String getActionId() => "setUserStatus";

  @override
  Future<String> callDidomiPlugin() async {
    final bool result = await DidomiSdk.setUserStatus(
        [purpose1, purpose2],
        [purpose3],
        [purpose1],
        [purpose2, purpose3],
        [vendor1, vendor2],
        [vendor3],
        [vendor1],
        [vendor2, vendor3]
    );
    return "Consent updated: $result.";
  }
}
