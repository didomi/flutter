import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.openCurrentUserStatusTransaction and disable multiple vendors from the transaction returned.
class DisableVendorsTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisableVendorsTransactionState();
}

class _DisableVendorsTransactionState extends BaseSampleWidgetState<DisableVendorsTransaction> {
  @override
  String getButtonName() => "DisableVendorsTransaction";

  @override
  String getActionId() => "disableVendorsTransaction";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();
    final entity = "ipromote";
    transaction.disableVendors([entity]);
    final updated = await transaction.commit();
    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.vendors?[entity]?.enabled;
    return "Updated: $updated, Enabled: $enabled.";
  }
}
