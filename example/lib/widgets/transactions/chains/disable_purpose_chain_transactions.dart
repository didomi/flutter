import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

class DisablePurposeChainTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisablePurposeChainTransactionsState();
}

class _DisablePurposeChainTransactionsState extends BaseSampleWidgetState<DisablePurposeChainTransactions> {
  @override
  String getButtonName() => "DisablePurposeChainTransactions";

  @override
  String getActionId() => "disablePurposeChainTransactions";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();

    final purpose1 = "cookies";
    final purpose2 = "select_basic_ads";
    final purpose3 = "create_ads_profile";
    final purpose4 = "select_personalized_ads";
    final purposes = [purpose1, purpose2, purpose3, purpose4];

    final updated = await transaction.disablePurpose(purpose1)
        .disablePurpose(purpose2)
        .disablePurposes([purpose3, purpose4])
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final disabled = purposes.map((e) => status.purposes?[e]?.enabled == false ? e : "");
    return "Updated: $updated, Disabled: $disabled.";
  }
}
