import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget used to call DidomiSdk.openCurrentUserStatusTransaction and enable multiple purposes from the transaction returned.
class EnablePurposesTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnablePurposesTransactionState();
}

class _EnablePurposesTransactionState extends BaseSampleWidgetState<EnablePurposesTransaction> {
  @override
  String getButtonName() => "EnablePurposesTransaction";

  @override
  String getActionId() => "enablePurposesTransaction";

  @override
  Future<String> callDidomiPlugin() async {
    final entity = "cookies";

    final updated = await DidomiSdk.openCurrentUserStatusTransaction()
        .enablePurposes([entity])
        .commit();

    final status = await DidomiSdk.currentUserStatus;
    final enabled = status.purposes?[entity]?.enabled;
    return "Updated: $updated, Enabled: $enabled.";
  }
}
