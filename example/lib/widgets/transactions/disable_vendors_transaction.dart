import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget used to call DidomiSdk.openCurrentUserStatusTransaction and disable multiple vendors from the transaction returned.
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
    final entity = "ipromote";

    final updated = await DidomiSdk.openCurrentUserStatusTransaction()
        .disableVendors([entity])
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.vendors?[entity]?.enabled;

    return "Updated: $updated, Enabled: $enabled.";
  }
}
