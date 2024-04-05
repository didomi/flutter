import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:didomi_sdk_example/widgets/transactions/constants.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.openCurrentUserStatusTransaction and enable a single vendor from the transaction returned.
class EnableVendorTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnableVendorTransactionState();
}

class _EnableVendorTransactionState extends BaseSampleWidgetState<EnableVendorTransaction> {
  @override
  String getButtonName() => "EnableVendorTransaction";

  @override
  String getActionId() => "enableVendorTransaction";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();
    final entity = "ipromote";
    transaction.enableVendor(entity);
    transaction.enablePurposes(allPurposeIds);
    final updated = await transaction.commit();
    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.vendors?[entity]?.enabled;
    return "Updated: $updated, Enabled: $enabled.";
  }
}