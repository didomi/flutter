import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:didomi_sdk_example/widgets/transactions/constants.dart';
import 'package:flutter/material.dart';

class EnableVendorChainTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnableVendorChainTransactionsState();
}

class _EnableVendorChainTransactionsState extends BaseSampleWidgetState<EnableVendorChainTransactions> {
  @override
  String getButtonName() => "EnableVendorChainTransactions";

  @override
  String getActionId() => "enableVendorChainTransactions";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();

    final vendor1 = "152media-Aa6Z6mLC";
    final vendor2 = "ipromote";
    final vendor3 = "amob-txzcQCyq";
    final vendors = [vendor1, vendor2, vendor3];

    final updated = await transaction.enableVendor(vendor1)
        .enableVendor(vendor2)
        .enableVendors([vendor3])
        .enablePurposes(allPurposeIds)
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final enabled = vendors.map((e) => status.vendors?[e]?.enabled == true ? e : "");
    return "Updated: $updated, Enabled: $enabled.";
  }
}
