import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.getTranslatedText
class GetTranslatedText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GetTranslatedTextState();
  }
}

class _GetTranslatedTextState extends BaseSampleWidgetState<GetTranslatedText> {
  TextEditingController _keyController =
      TextEditingController(text: "notice.content.notice");

  @override
  String getButtonName() {
    return 'Get translated text';
  }

  @override
  String getActionId() {
    return 'getTranslatedText';
  }

  @override
  Future<String> callDidomiPlugin() async {
    String result = await DidomiSdk.getTranslatedText(_keyController.text);
    return result;
  }

  @override
  List<Widget> buildWidgets() {
    return [
      ElevatedButton(
        child: Text(getButtonName()),
        onPressed: requestAction,
        key: Key(getActionId()),
      ),
      Text('With language code: \n'),
      TextFormField(
          controller: _keyController,
          key: Key("getTranslatedTextKey"),
          decoration: InputDecoration(labelText: 'Key')),
      buildResponseText(getActionId())
    ];
  }
}
