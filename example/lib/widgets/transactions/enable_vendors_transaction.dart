import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:didomi_sdk_example/widgets/transactions/constants.dart';
import 'package:flutter/material.dart';

/// Widget used to call DidomiSdk.openCurrentUserStatusTransaction and enable multiple vendors from the transaction returned.
class EnableVendorsTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnableVendorsTransactionState();
}

class _EnableVendorsTransactionState extends BaseSampleWidgetState<EnableVendorsTransaction> {
  @override
  String getButtonName() => "EnableVendorsTransaction";

  @override
  String getActionId() => "enableVendorsTransaction";

  @override
  Future<String> callDidomiPlugin() async {
    final entity = "ipromote";

    final updated = await DidomiSdk.openCurrentUserStatusTransaction()
        .enableVendors([entity])
        .enablePurposes(allPurposeIds)
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.vendors?[entity]?.enabled;

    return "Updated: $updated, Enabled: $enabled.";
  }
}
