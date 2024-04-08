import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget used to call DidomiSdk.openCurrentUserStatusTransaction and disable multiple purposes from the transaction returned.
class DisablePurposesTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisablePurposesTransactionState();
}

class _DisablePurposesTransactionState extends BaseSampleWidgetState<DisablePurposesTransaction> {
  @override
  String getButtonName() => "DisablePurposesTransaction";

  @override
  String getActionId() => "disablePurposesTransaction";

  @override
  Future<String> callDidomiPlugin() async {
    final entity = "cookies";

    final updated = await DidomiSdk.openCurrentUserStatusTransaction()
        .disablePurposes([entity])
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.purposes?[entity]?.enabled;

    return "Updated: $updated, Enabled: $enabled.";
  }
}
