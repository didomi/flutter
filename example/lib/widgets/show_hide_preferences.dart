import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/preferences_view.dart';

/// Widget to call DidomiSdk.showPreferences
class ShowHidePreferences extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowHidePreferencesState();
  }
}

class _ShowHidePreferencesState extends BaseSampleWidgetState<ShowHidePreferences> {

  static const HIDE_DELAY_SECONDS = 5;

  PreferencesView? _requestedView = PreferencesView.purposes;
  bool _hideAfterAWhile = false;

  @override
  String getButtonName() {
    return 'Show preferences';
  }

  @override
  String getActionId() {
    return 'showPreferences';
  }

  @override
  Future<String> callDidomiPlugin() async {
    PreferencesView? requestedView = _requestedView;
    if (requestedView != null) {
      if (_hideAfterAWhile) {
        Future.delayed(const Duration(seconds: HIDE_DELAY_SECONDS), () => DidomiSdk.hidePreferences());
      }
      await DidomiSdk.showPreferences(view: requestedView);
    }
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
      Column(
        children: <Widget>[
          RadioListTile<PreferencesView>(
            title: const Text('Purposes'),
            value: PreferencesView.purposes,
            groupValue: _requestedView,
            onChanged: (PreferencesView? value) {
              setState(() {
                _requestedView = value;
              });
            },
          ),
          RadioListTile<PreferencesView>(
            title: const Text('Vendors'),
            value: PreferencesView.vendors,
            groupValue: _requestedView,
            onChanged: (PreferencesView? value) {
              setState(() {
                _requestedView = value;
              });
            },
          ),
        ],
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