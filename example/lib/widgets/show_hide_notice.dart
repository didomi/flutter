import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.showNotice
class ShowHideNotice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowHideNoticeState();
}

class _ShowHideNoticeState extends BaseSampleWidgetState<ShowHideNotice> {
  static const HIDE_DELAY_SECONDS = 3;
  static const CHECK_DELAY_SECONDS = 5;

  bool _hideAfterAWhile = false;
  bool _checkVisibilityAfterAWhile = false;

  @override
  String getButtonName() => "Show notice";

  @override
  String getActionId() => "showNotice";

  @override
  Future<String> callDidomiPlugin() async {
    if (_hideAfterAWhile) {
      Future.delayed(const Duration(seconds: HIDE_DELAY_SECONDS), () => DidomiSdk.hideNotice());
    }
    if (_checkVisibilityAfterAWhile) {
      Future.delayed(const Duration(seconds: CHECK_DELAY_SECONDS), () => checkVisibility());
    }
    await DidomiSdk.showNotice();
    return 'OK';
  }

  Future<void> checkVisibility() async {
    bool visible = await DidomiSdk.isNoticeVisible;
    String text = visible ? "Yes, notice is visible" : "No, Notice is not visible";

    await showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Check notice visibility"),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  List<Widget> buildWidgets() => [
      ElevatedButton(
        child: Text(getButtonName()),
        onPressed: requestAction,
        key: Key(getActionId()),
      ),
      CheckboxListTile(
        title: Text("Hide after $HIDE_DELAY_SECONDS seconds"),
        key: Key("hideNotice"),
        value: _hideAfterAWhile,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _hideAfterAWhile = newValue;
            });
          }
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      CheckboxListTile(
        title: Text("Check visibility after $CHECK_DELAY_SECONDS seconds"),
        key: Key("isNoticeVisible"),
        value: _checkVisibilityAfterAWhile,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _checkVisibilityAfterAWhile = newValue;
            });
          }
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      buildResponseText(getActionId())
    ];
}
