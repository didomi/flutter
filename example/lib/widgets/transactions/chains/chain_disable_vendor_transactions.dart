import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:didomi_sdk_example/widgets/transactions/constants.dart';
import 'package:flutter/material.dart';

/// Widget used to call DidomiSdk.openCurrentUserStatusTransaction and disable vendors using chain calls from the transaction returned.
class ChainDisableVendorTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChainDisableVendorTransactionsState();
}

class _ChainDisableVendorTransactionsState extends BaseSampleWidgetState<ChainDisableVendorTransactions> {
  @override
  String getButtonName() => "ChainDisableVendorTransactions";

  @override
  String getActionId() => "chainDisableVendorTransactions";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = DidomiSdk.openCurrentUserStatusTransaction();

    final vendor1 = "152media-Aa6Z6mLC";
    final vendor2 = "ipromote";
    final vendor3 = "amob-Vd2fVzAM";

    final ids = [vendor1, vendor2, vendor3];

    final updated = await transaction.disableVendor(vendor1)
        .disableVendor(vendor2)
        .disableVendors([vendor3])
        .disablePurposes(allPurposeIds)
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final disabledIds = ids.map((id) => status.vendors?[id]?.enabled == false ? id : "");

    return "Updated: $updated, Disabled: $disabledIds.";
  }
}
