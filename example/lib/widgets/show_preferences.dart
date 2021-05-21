import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/preferences_view.dart';

/// Widget to call DidomiSdk.showPreferences
class ShowPreferences extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowPreferencesState();
  }
}

class _ShowPreferencesState extends BaseSampleWidgetState<ShowPreferences> {

  /// Requested view to open
  PreferencesView? _requestedView = PreferencesView.purposes;

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
      )
    ];
  }
}