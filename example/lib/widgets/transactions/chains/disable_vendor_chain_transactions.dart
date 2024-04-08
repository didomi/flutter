import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:didomi_sdk_example/widgets/transactions/constants.dart';
import 'package:flutter/material.dart';

class DisableVendorChainTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisableVendorChainTransactionsState();
}

class _DisableVendorChainTransactionsState extends BaseSampleWidgetState<DisableVendorChainTransactions> {
  @override
  String getButtonName() => "DisableVendorChainTransactions";

  @override
  String getActionId() => "disableVendorChainTransactions";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();

    final vendor1 = "152media-Aa6Z6mLC";
    final vendor2 = "ipromote";
    final vendor3 = "amob-txzcQCyq";
    final vendors = [vendor1, vendor2, vendor3];

    final updated = await transaction.disableVendor(vendor1)
        .disableVendor(vendor2)
        .disableVendors([vendor3])
        .disablePurposes(allPurposeIds)
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final disabled = vendors.map((e) => status.vendors?[e]?.enabled == false ? e : "");
    return "Updated: $updated, Disabled: $disabled.";
  }
}
