import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.openCurrentUserStatusTransaction and disable a single purpose from the transaction returned.
class DisablePurposeTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisablePurposeTransactionState();
}

class _DisablePurposeTransactionState extends BaseSampleWidgetState<DisablePurposeTransaction> {
  @override
  String getButtonName() => "DisablePurposeTransaction";

  @override
  String getActionId() => "disablePurposeTransaction";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();
    final entity = "cookies";
    transaction.disablePurpose(entity);
    final updated = await transaction.commit();
    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.purposes?[entity]?.enabled;
    return "Updated: $updated, Enabled: $enabled.";
  }
}
