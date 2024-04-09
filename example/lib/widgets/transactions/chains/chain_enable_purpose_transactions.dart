import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget used to call DidomiSdk.openCurrentUserStatusTransaction and enable purposes using chain calls from the transaction returned.
class ChainEnablePurposeTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChainEnablePurposeTransactionsState();
}

class _ChainEnablePurposeTransactionsState extends BaseSampleWidgetState<ChainEnablePurposeTransactions> {
  @override
  String getButtonName() => "ChainEnablePurposeTransactions";

  @override
  String getActionId() => "chainEnablePurposeTransactions";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();

    final purpose1 = "cookies";
    final purpose2 = "select_basic_ads";
    final purpose3 = "create_ads_profile";
    final purpose4 = "select_personalized_ads";

    final ids = [purpose1, purpose2, purpose3, purpose4];

    final updated = await transaction.enablePurpose(purpose1)
        .enablePurpose(purpose2)
        .enablePurposes([purpose3, purpose4])
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final enabledIds = ids.map((id) => status.purposes?[id]?.enabled == true ? id : "");

    return "Updated: $updated, Enabled: $enabledIds.";
  }
}
