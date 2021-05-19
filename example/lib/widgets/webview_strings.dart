import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk getJavaScriptForWebView / getQueryStringForWebView
class WebviewStrings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebviewStringsState();
  }
}

class _WebviewStringsState extends BaseSampleWidgetState<WebviewStrings> {
  @override
  String getButtonName() {
    return 'Get Webview Strings';
  }

  @override
  String getActionId() {
    return 'getWebviewStrings';
  }

  @override
  Future<String> callDidomiPlugin() async {
    String javascriptString = await DidomiSdk.getJavaScriptForWebView();
    String queryString = await DidomiSdk.getQueryStringForWebView();

    await showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Webview Strings'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("JavaScript for Webview:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
                Text("$javascriptString\n"),
                Text("Query String for Webview:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
                Text(queryString),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return 'OK';
  }
}
