import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/vendor.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getEnabledVendors
class GetEnabledVendors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetEnabledVendorsState();
}

class _GetEnabledVendorsState
    extends BaseSampleWidgetState<GetEnabledVendors> {
  @override
  String getButtonName() => 'GetEnabledVendors';

  @override
  String getActionId() => 'getEnabledVendors';

  @override
  Future<String> callDidomiPlugin() async {
    final List<Vendor> result = await DidomiSdk.enabledVendors;
    result.sort(); // Required for UI tests

    final String printable = result.map((vendor) => vendor.name).join(", ");
    print(printable);

    if (result.isEmpty) {
      return "Enabled Vendor list is empty.";
    } else {
      return "Enabled Vendors: $printable.";
    }
  }
}
