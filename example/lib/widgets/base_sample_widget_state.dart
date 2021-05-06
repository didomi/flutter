import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

abstract class BaseSampleWidgetState<T extends StatefulWidget> extends State<T> {
  String _messageFromNative = "--";

  Widget buildResponseText(String key) {
    return Text('Native message: $_messageFromNative\n',
        key: Key('nativeResponse_$key'));
  }

  Future<void> updateMessageFromNative(String messageFromNative) async {
    if (!mounted) return;

    setState(() {
      _messageFromNative = messageFromNative;
    });
  }

  String getButtonName();

  String getActionId();

  Future<String> callDidomiPlugin();

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
