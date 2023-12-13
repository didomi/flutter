import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/vendor.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getVendor
class GetVendor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetVendorState();
}

class _GetVendorState
    extends BaseSampleWidgetState<GetVendor> {
  @override
  String getButtonName() => "GetVendor";

  @override
  String getActionId() => "getVendor";

  @override
  Future<String> callDidomiPlugin() async {
    final Vendor? result = await DidomiSdk.getVendor("1111");

    if (result == null) {
      return "Vendor does not exist.";
    } else {
      return "Vendor: ${result.name}.";
    }
  }
}
