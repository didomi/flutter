import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget used to call DidomiSdk.openCurrentUserStatusTransaction and disable purposes using chain calls from the transaction returned.
class ChainDisablePurposeTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChainDisablePurposeTransactionsState();
}

class _ChainDisablePurposeTransactionsState extends BaseSampleWidgetState<ChainDisablePurposeTransactions> {
  @override
  String getButtonName() => "ChainDisablePurposeTransactions";

  @override
  String getActionId() => "chainDisablePurposeTransactions";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();

    final purpose1 = "cookies";
    final purpose2 = "select_basic_ads";
    final purpose3 = "create_ads_profile";
    final purpose4 = "select_personalized_ads";

    final ids = [purpose1, purpose2, purpose3, purpose4];

    final updated = await transaction.disablePurpose(purpose1)
        .disablePurpose(purpose2)
        .disablePurposes([purpose3, purpose4])
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final disabledIds = ids.map((id) => status.purposes?[id]?.enabled == false ? id : "");

    return "Updated: $updated, Disabled: $disabledIds.";
  }
}
