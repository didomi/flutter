import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk getJavaScriptForWebView / getQueryStringForWebView
class WebviewStrings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WebviewStringsState();
}

class _WebviewStringsState extends BaseSampleWidgetState<WebviewStrings> {
  @override
  String getButtonName() => "Get Webview Strings";

  @override
  String getActionId() => "getWebviewStrings";

  @override
  Future<String> callDidomiPlugin() async {
    String javascriptString = await DidomiSdk.javaScriptForWebView;
    String queryString = await DidomiSdk.queryStringForWebView;

    await showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) => AlertDialog(
          title: const Text("Webview Strings"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("JavaScript for Webview:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("$javascriptString\n"),
                Text("Query String for Webview:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(queryString),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
    );

    return "OK";
  }
}
