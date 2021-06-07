import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/vendor.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getRequiredVendors
class GetRequiredVendors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetRequiredVendorsState();
}

class _GetRequiredVendorsState
    extends BaseSampleWidgetState<GetRequiredVendors> {
  @override
  String getButtonName() => "GetRequiredVendors";

  @override
  String getActionId() => "getRequiredVendors";

  @override
  Future<String> callDidomiPlugin() async {
    final List<Vendor>? result = await DidomiSdk.requiredVendors;
    result?.sort(); // Required for UI tests

    final String? printable = result?.map((vendor) => vendor.name).join(", ");
    print(printable);

    if (result == null || result.isEmpty) {
      return "Required Vendor list is empty.";
    } else {
      return "Required Vendors: $printable.";
    }
  }
}
