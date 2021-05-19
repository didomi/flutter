import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

/// Base state for Widgets testing Didomi SDK functionality
abstract class BaseSampleWidgetState<T extends StatefulWidget> extends State<T> {
  String _messageFromNative = "--";

  /// A Text displaying SDK response
  Widget buildResponseText(String key) {
    return Text('Native message: $_messageFromNative\n',
        key: Key('nativeResponse_$key'));
  }

  /// Update displayed SDK response
  Future<void> updateMessageFromNative(String messageFromNative) async {
    if (!mounted) return;

    setState(() {
      _messageFromNative = messageFromNative;
    });
  }

  /// Label of the action button
  String getButtonName();

  /// Action id for button and response text keys
  String getActionId();

  /// Action to call the Didomi SDK.
  /// Return description of the result, to display in Text component
  Future<String> callDidomiPlugin();

  /// Triggers the action linked to the component
  Future<void> requestAction() async {
    String messageFromNative;
    try {
      messageFromNative = await callDidomiPlugin();
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }

    updateMessageFromNative(messageFromNative);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
        child: Text(getButtonName()),
        key: Key(getActionId()),
        onPressed: requestAction,
      ),
      buildResponseText(getActionId())
    ]);
  }
}
