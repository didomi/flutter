import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.initialize
class Initialize extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InitializeState();
  }
}

class _InitializeState extends BaseSampleWidgetState<Initialize> {

  @override
  String getButtonName() {
    return 'Initialize SDK';
  }

  @override
  String getActionId() {
    return 'initialize';
  }

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.initialize(_apiKeyController.text,
        disableDidomiRemoteConfig: _disableRemoteConfigValue,
        languageCode: _languageController.text,
        noticeId: _noticeIdController.text);
    return 'OK';
  }

  TextEditingController _apiKeyController =
  TextEditingController(text: "b5c8560d-77c7-4b1e-9200-954c0693ae1a");

  TextEditingController _noticeIdController =
  TextEditingController(text: "NDQxnJbk");

  TextEditingController _languageController = TextEditingController();

  bool _disableRemoteConfigValue = false;

  @override
  List<Widget> buildWidgets() {
    return [
      ElevatedButton(
        child: Text(getButtonName()),
        onPressed: requestAction,
        key: Key(getActionId()),
      ),
      Text('With parameters: \n'),
      TextFormField(
          controller: _apiKeyController,
          key: Key("apiKey"),
          decoration: InputDecoration(labelText: 'API Key')),
      TextFormField(
          controller: _noticeIdController,
          decoration: InputDecoration(labelText: 'Notice id')),
      TextFormField(
          controller: _languageController,
          decoration: InputDecoration(labelText: 'Language code')),
      CheckboxListTile(
        title: Text("Disable remote config"),
        key: Key('disableRemoteConfig'),
        value: _disableRemoteConfigValue,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _disableRemoteConfigValue = newValue;
            });
          }
        },
        controlAffinity:
        ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      buildResponseText(getActionId())
    ];
  }
}