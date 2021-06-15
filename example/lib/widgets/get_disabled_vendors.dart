import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/vendor.dart';
import 'package:didomi_sdk_example/extensions/list.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getDisabledVendors
class GetDisabledVendors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetDisabledVendorsState();
}

class _GetDisabledVendorsState
    extends BaseSampleWidgetState<GetDisabledVendors> {
  @override
  String getButtonName() => "GetDisabledVendors";

  @override
  String getActionId() => "getDisabledVendors";

  @override
  Future<String> callDidomiPlugin() async {
    final List<Vendor> result = await DidomiSdk.disabledVendors;
    result.sort(); // Required for UI tests

    if (result.isEmpty) {
      return "Disabled Vendor list is empty.";
    } else {
      return "Disabled Vendors: ${result.joinToString()}.";
    }
  }
}
