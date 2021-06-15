import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/extensions/map.dart';
import 'package:didomi_sdk_example/extensions/splay_tree_map.dart';
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
    if (result == null) {
      return "\nNo result";
    } else {
      // Sort result for UI tests
      final sorted = result.sortByKey();
      // Pretty print for content
      return sorted.pretty("\n");
    }
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
