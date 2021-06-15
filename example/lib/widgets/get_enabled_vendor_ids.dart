import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/extensions/list.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getEnabledVendorIds
class GetEnabledVendorIds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetEnabledVendorIdsState();
}

class _GetEnabledVendorIdsState extends BaseSampleWidgetState<GetEnabledVendorIds> {
  @override
  String getButtonName() => "GetEnabledVendorIds";

  @override
  String getActionId() => "getEnabledVendorIds";

  @override
  Future<String> callDidomiPlugin() async {
    final List<String> result = await DidomiSdk.enabledVendorIds;
    result.sort(); // Required for UI tests
    if (result.isEmpty) {
      return "Enabled Vendor list is empty.";
    } else {
      return "Enabled Vendors: ${result.pretty()}.";
    }
  }
}
