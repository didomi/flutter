import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/extensions/list.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getRequiredVendorIds
class GetRequiredVendorIds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetRequiredVendorIdsState();
}

class _GetRequiredVendorIdsState extends BaseSampleWidgetState<GetRequiredVendorIds> {
  @override
  String getButtonName() => "GetRequiredVendorIds";

  @override
  String getActionId() => "getRequiredVendorIds";

  @override
  Future<String> callDidomiPlugin() async {
    final List<String> result = await DidomiSdk.requiredVendorIds;
    result.sort(); // Required for UI tests
    if (result.isEmpty) {
      return "Required Vendor list is empty.";
    } else {
      return "Required Vendors: ${result.pretty()}.";
    }
  }
}
