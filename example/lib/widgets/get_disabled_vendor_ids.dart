import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getDisabledVendorIds
class GetDisabledVendorIds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetDisabledVendorIds();
}

class _GetDisabledVendorIds
    extends BaseSampleWidgetState<GetDisabledVendorIds> {
  @override
  String getButtonName() => 'GetDisabledVendorIds';

  @override
  String getActionId() => 'getDisabledVendorIds';

  @override
  Future<String> callDidomiPlugin() async {
    final List<String> result = await DidomiSdk.disabledVendorIds;
    if (result.isEmpty) {
      return "Disabled Vendors list is empty";
    } else {
      return "Disabled Vendors: ${result.join(",")}";
    }
  }
}
