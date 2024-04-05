import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.openCurrentUserStatusTransaction and disable a single vendor from the transaction returned.
class DisableVendorTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisableVendorTransactionState();
}

class _DisableVendorTransactionState extends BaseSampleWidgetState<DisableVendorTransaction> {
  @override
  String getButtonName() => "DisableVendorTransaction";

  @override
  String getActionId() => "disableVendorTransaction";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();
    final entity = "ipromote";
    transaction.disableVendor(entity);
    final updated = await transaction.commit();
    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.vendors?[entity]?.enabled;
    return "Updated: $updated, Enabled: $enabled.";
  }
}
