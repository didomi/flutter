import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/preferences_view.dart';

/// Widget to call DidomiSdk.showPreferences
class ShowHideNotice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowHideNoticeState();
  }
}

class _ShowHideNoticeState extends BaseSampleWidgetState<ShowHideNotice> {

  static const HIDE_DELAY_SECONDS = 5;

  bool _hideAfterAWhile = false;

  @override
  String getButtonName() {
    return 'Show notice';
  }

  @override
  String getActionId() {
    return 'showNotice';
  }

  @override
  Future<String> callDidomiPlugin() async {
    if (_hideAfterAWhile) {
      Future.delayed(const Duration(seconds: HIDE_DELAY_SECONDS), () => DidomiSdk.hideNotice());
    }
    await DidomiSdk.showNotice();
    return 'OK';
  }

  @override
  List<Widget> buildWidgets() {
    return [
      ElevatedButton(
        child: Text(getButtonName()),
        onPressed: requestAction,
        key: Key(getActionId()),
      ),
      CheckboxListTile(
        title: Text("Hide after $HIDE_DELAY_SECONDS seconds"),
        key: Key('disableRemoteConfig'),
        value: _hideAfterAWhile,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _hideAfterAWhile = newValue;
            });
          }
        },
        controlAffinity:
        ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      buildResponseText(getActionId())
    ];
  }
}