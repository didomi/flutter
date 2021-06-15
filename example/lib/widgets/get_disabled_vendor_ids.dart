import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/extensions/list.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getDisabledVendorIds
class GetDisabledVendorIds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetDisabledVendorIdsState();
}

class _GetDisabledVendorIdsState extends BaseSampleWidgetState<GetDisabledVendorIds> {
  @override
  String getButtonName() => "GetDisabledVendorIds";

  @override
  String getActionId() => "getDisabledVendorIds";

  @override
  Future<String> callDidomiPlugin() async {
    final List<String> result = await DidomiSdk.disabledVendorIds;
    result.sort(); // Required for UI tests
    if (result.isEmpty) {
      return "Disabled Vendor list is empty.";
    } else {
      return "Disabled Vendors: ${result.joinToString()}.";
    }
  }
}
