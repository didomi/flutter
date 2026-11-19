import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/entities/regulation_configuration.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.applicableRegulationConfiguration
class GetApplicableRegulationConfiguration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetApplicableRegulationConfigurationState();
}

class _GetApplicableRegulationConfigurationState extends BaseSampleWidgetState<GetApplicableRegulationConfiguration> {
  @override
  String getButtonName() => "GetApplicableRegulationConfiguration";

  @override
  String getActionId() => "getApplicableRegulationConfiguration";

  @override
  Future<String> callDidomiPlugin() async {
    final RegulationConfiguration? result = await DidomiSdk.applicableRegulationConfiguration;
    if (result == null) return "Result = null";
    return "Result = id: ${result.id}, versionId: ${result.versionId}, numericalId: ${result.numericalId}, "
        "regulationName: ${result.regulationName}, tokenStorageName: ${result.tokenStorageName}, mixed: ${result.mixed}";
  }
}
