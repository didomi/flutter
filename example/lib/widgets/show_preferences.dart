import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

class _ShowPreferencesState extends BaseSampleWidgetState<ShowPreferences> {

  @override
  String getButtonName() {
    return 'Show preferences';
  }

  @override
  String getActionId() {
    return 'showPreferences';
  }

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.showPreferences();
    return 'OK';
  }
}

class ShowPreferences extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowPreferencesState();
  }
}