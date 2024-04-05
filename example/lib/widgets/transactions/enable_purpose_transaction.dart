import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.openCurrentUserStatusTransaction and enable a single purpose from the transaction returned.
class EnablePurposeTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnablePurposeTransactionState();
}

class _EnablePurposeTransactionState extends BaseSampleWidgetState<EnablePurposeTransaction> {
  @override
  String getButtonName() => "EnablePurposeTransaction";

  @override
  String getActionId() => "enablePurposeTransaction";

  @override
  Future<String> callDidomiPlugin() async {
    final transaction = await DidomiSdk.openCurrentUserStatusTransaction();
    final entity = "cookies";
    transaction.enablePurpose(entity);
    final updated = await transaction.commit();
    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.purposes?[entity]?.enabled;
    return "Updated: $updated, Enabled: $enabled.";
  }
}
