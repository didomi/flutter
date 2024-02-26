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
    final Vendor? result = await DidomiSdk.getVendor("217");

    if (result == null) {
      return "Vendor does not exist.";
    } else {
      Url url = result.urls?.find((element) => element.langId == "en") ?? result.urls![0];

      return "Vendor: ${result.name}. Purposes: ${result.purposeIds.length} consent, "
          "${result.legIntPurposeIds.length} LI, ${result.featureIds.length} features, "
          "${result.specialPurposeIds.length} special purposes, ${result.specialFeatureIds.length} special features."
          "URL 0: ${result.urls?[0].langId} -> ${result.urls?[0].privacy} - ${result.urls?[0].legIntClaim}."
          "IAB2 = ${result.namespaces?.iab2}";
    }
  }
}
