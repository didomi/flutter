import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.initialize
class InitializeSmall extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitializeSmallState();
}

class _InitializeSmallState extends BaseSampleWidgetState<InitializeSmall> {
  @override
  String getButtonName() => "Initialize SDK";

  @override
  String getActionId() => "initializeSmall";

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.initialize("c3cd5b46-bf36-4700-bbdc-4ee9176045aa", disableDidomiRemoteConfig: false, languageCode: null, noticeId: "KfwVrwCy");
    return "OK";
  }
}
