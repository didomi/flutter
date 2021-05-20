import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.initialize
class InitializeSmall extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InitializeSmallState();
  }
}

class _InitializeSmallState extends BaseSampleWidgetState<InitializeSmall> {
  @override
  String getButtonName() => "Initialize SDK";

  @override
  String getActionId() => "initializeSmall";

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.initialize("b5c8560d-77c7-4b1e-9200-954c0693ae1a", disableDidomiRemoteConfig: false, languageCode: null, noticeId: "NDQxnJbk");
    return "OK";
  }
}
