import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/parameters/didomi_widget_parameters.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.showWidget
class ShowWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowWidgetState();
}

class _ShowWidgetState extends BaseSampleWidgetState<ShowWidget> {
  TextEditingController _widgetIdController = TextEditingController(text: "widget_cpra");

  TextEditingController _layerNameController = TextEditingController();

  @override
  String getButtonName() => "Show widget";

  @override
  String getActionId() => "showWidget";

  @override
  Future<String> callDidomiPlugin() async {
    String widgetId = _widgetIdController.text;
    String layerName = _layerNameController.text;
    await DidomiSdk.showWidget(DidomiWidgetParameters(
        widgetId: widgetId.isEmpty ? null : widgetId, layerName: layerName.isEmpty ? null : layerName));
    return "OK";
  }

  @override
  List<Widget> buildWidgets() => [
        ElevatedButton(
          child: Text(getButtonName()),
          onPressed: requestAction,
          key: Key(getActionId()),
        ),
        TextFormField(controller: _widgetIdController, key: Key("widgetId"), decoration: InputDecoration(labelText: 'Widget id')),
        TextFormField(controller: _layerNameController, key: Key("layerName"), decoration: InputDecoration(labelText: 'Layer name')),
        buildResponseText(getActionId())
      ];
}
