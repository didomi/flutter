import 'dart:async';
import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/parameters/didomi_initialize_parameters.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.initialize with a local configuration containing a regulation configuration
class InitializeCustomRegulation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitializeCustomRegulationState();
}

class _InitializeCustomRegulationState extends BaseSampleWidgetState<InitializeCustomRegulation> {
  @override
  String getButtonName() => "Initialize custom regulation";

  @override
  String getActionId() => "initializeCustomRegulation";

  @override
  Future<String> callDidomiPlugin() async {
    // Local configuration with a regulation configuration, so that tests don't depend on geolocation
    await DidomiSdk.initializeWithParameters(DidomiInitializeParameters(
        apiKey: "9bf8a7e4-db9a-4ff2-a45c-ab7d2b6eadba",
        localConfigurationPath: Platform.isIOS ? "didomi_config_custom_regulation" : "didomi_config_custom_regulation.json",
        // ignore: deprecated_member_use
        disableDidomiRemoteConfig: true));
    return "OK";
  }
}
