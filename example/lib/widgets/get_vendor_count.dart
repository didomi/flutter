import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getVendorCount
class GetVendorCount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetVendorCountState();
}

class _GetVendorCountState
    extends BaseSampleWidgetState<GetVendorCount> {
  @override
  String getButtonName() => "GetVendorCount";

  @override
  String getActionId() => "getVendorCount";

  @override
  Future<String> callDidomiPlugin() async {
    final int totalCount = await DidomiSdk.getTotalVendorCount();
    final int iabCount = await DidomiSdk.getIabVendorCount();
    final int nonIabCount = await DidomiSdk.getNonIabVendorCount();

    return "$totalCount vendors in total, $iabCount IAB vendors, $nonIabCount non-IAB vendors.";
  }
}
