import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.initialize
class Initialize extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InitializeState();
}

class _InitializeState extends BaseSampleWidgetState<Initialize> {
  @override
  String getButtonName() => "Initialize SDK";

  @override
  String getActionId() => "initialize";

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.initialize(_apiKeyController.text,
        disableDidomiRemoteConfig: _disableRemoteConfigValue, languageCode: _languageController.text, noticeId: _noticeIdController.text);
    return "OK";
  }

  TextEditingController _apiKeyController = TextEditingController(text: "c3cd5b46-bf36-4700-bbdc-4ee9176045aa");

  TextEditingController _noticeIdController = TextEditingController(text: "KfwVrwCy");

  TextEditingController _languageController = TextEditingController();

  bool _disableRemoteConfigValue = false;

  @override
  List<Widget> buildWidgets() => [
        ElevatedButton(
          child: Text(getButtonName()),
          onPressed: requestAction,
          key: Key(getActionId()),
        ),
        Text('With parameters: \n'),
        TextFormField(controller: _apiKeyController, key: Key("apiKey"), decoration: InputDecoration(labelText: 'API Key')),
        TextFormField(controller: _noticeIdController, decoration: InputDecoration(labelText: 'Notice id')),
        TextFormField(controller: _languageController, decoration: InputDecoration(labelText: 'Language code')),
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
          controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
        ),
        buildResponseText(getActionId())
      ];
}
