import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.updateSelectedLanguage
class UpdateSelectedLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpdateSelectedLanguageState();
  }
}

class _UpdateSelectedLanguageState extends BaseSampleWidgetState<UpdateSelectedLanguage> {

  TextEditingController _languageCodeController =
  TextEditingController(text: "zh-CN");

  @override
  String getButtonName() {
    return "Update selected language";
  }

  @override
  String getActionId() {
    return "updateSelectedLanguage";
  }

  @override
  Future<String> callDidomiPlugin() async {
    await DidomiSdk.updateSelectedLanguage(_languageCodeController.text);
    return "OK";
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
      TextFormField(
          controller: _languageCodeController,
          key: Key("languageCodeToUpdate"),
          decoration: InputDecoration(labelText: "Language code")),
      buildResponseText(getActionId())
    ];
  }
}
