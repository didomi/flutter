import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.getText
class GetText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GetTextState();
  }
}

class _GetTextState extends BaseSampleWidgetState<GetText> {
  TextEditingController _keyController = TextEditingController(text: "notice.content.notice");

  @override
  String getButtonName() => "Get text";

  @override
  String getActionId() => "getText";

  @override
  Future<String> callDidomiPlugin() async {
    Map<String, String>? result = await DidomiSdk.getText(_keyController.text);
    StringBuffer sb = StringBuffer("\n");
    if (result == null) {
      sb.writeln("No result");
    } else {
      result.entries.forEach((element) {
        sb.writeln("${element.key} =>");
        sb.writeln(element.value);
      });
    }
    return sb.toString();
  }

  @override
  List<Widget> buildWidgets() {
    return [
      ElevatedButton(
        child: Text(getButtonName()),
        onPressed: requestAction,
        key: Key(getActionId()),
      ),
      Text("With language code: \n"),
      TextFormField(controller: _keyController, key: Key("getTextKey"), decoration: InputDecoration(labelText: "Key")),
      buildResponseText(getActionId())
    ];
  }
}
