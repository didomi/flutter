import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:didomi_sdk_example/widgets/transactions/constants.dart';
import 'package:flutter/material.dart';

class EnablePurposeChainTransactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnablePurposeChainTransactionsState();
}

class _EnablePurposeChainTransactionsState extends BaseSampleWidgetState<EnablePurposeChainTransactions> {
  @override
  String getButtonName() => "EnablePurposeChainTransactions";

  @override
  String getActionId() => "enablePurposeChainTransactions";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();

    final purpose1 = "cookies";
    final purpose2 = "select_basic_ads";
    final purpose3 = "create_ads_profile";
    final purpose4 = "select_personalized_ads";
    final purposes = [purpose1, purpose2, purpose3, purpose4];

    final updated = await transaction.enablePurpose(purpose1)
        .enablePurpose(purpose2)
        .enablePurposes([purpose3, purpose4])
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final enabled = purposes.map((e) => status.purposes?[e]?.enabled == true ? e : "");
    return "Updated: $updated, Enabled: $enabled.";
  }
}
