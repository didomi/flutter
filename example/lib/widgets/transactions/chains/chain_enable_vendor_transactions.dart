import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:didomi_sdk_example/widgets/transactions/constants.dart';
import 'package:flutter/material.dart';

/// Widget used to call DidomiSdk.openCurrentUserStatusTransaction and enable vendors using chain calls from the transaction returned.
class ChainEnableVendorTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChainEnableVendorTransactionsState();
}

class _ChainEnableVendorTransactionsState extends BaseSampleWidgetState<ChainEnableVendorTransactions> {
  @override
  String getButtonName() => "ChainEnableVendorTransactions";

  @override
  String getActionId() => "chainEnableVendorTransactions";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = DidomiSdk.openCurrentUserStatusTransaction();

    final vendor1 = "152media-Aa6Z6mLC";
    final vendor2 = "ipromote";
    final vendor3 = "amob-Vd2fVzAM";

    final ids = [vendor1, vendor2, vendor3];

    final updated = await transaction.enableVendor(vendor1)
        .enableVendor(vendor2)
        .enableVendors([vendor3])
        .enablePurposes(allPurposeIds)
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final enabledIds = ids.map((id) => status.vendors?[id]?.enabled == true ? id : "");

    return "Updated: $updated, Enabled: $enabledIds.";
  }
}
