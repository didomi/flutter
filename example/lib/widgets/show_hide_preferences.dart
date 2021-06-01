import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/preferences_view.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.showPreferences
class ShowHidePreferences extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowHidePreferencesState();
}

class _ShowHidePreferencesState extends BaseSampleWidgetState<ShowHidePreferences> {
  static const HIDE_DELAY_SECONDS = 3;
  static const CHECK_DELAY_SECONDS = 5;

  PreferencesView? _requestedView = PreferencesView.purposes;
  bool _hideAfterAWhile = false;
  bool _checkVisibilityAfterAWhile = false;

  @override
  String getButtonName() => "Show preferences";

  @override
  String getActionId() => "showPreferences";

  @override
  Future<String> callDidomiPlugin() async {
    PreferencesView? requestedView = _requestedView;
    if (requestedView != null) {
      if (_hideAfterAWhile) {
        Future.delayed(const Duration(seconds: HIDE_DELAY_SECONDS), () {
          // TODO('Remove this once hide preference is fixed on native sdks')
          if (requestedView == PreferencesView.vendors) {
            DidomiSdk.hidePreferences();
          }
          return DidomiSdk.hidePreferences();
        });
      }
      if (_checkVisibilityAfterAWhile) {
        Future.delayed(const Duration(seconds: CHECK_DELAY_SECONDS), () => checkVisibility());
      }
      await DidomiSdk.showPreferences(view: requestedView);
    }
    return "OK";
  }

  Future<void> checkVisibility() async {
    bool visible = await DidomiSdk.isPreferencesVisible;
    String text = visible ? "Yes, Preferences screen is visible" : "No, Preferences screen is not visible";

    await showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Check Preferences screen visibility"),
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
        Column(
          children: <Widget>[
            RadioListTile<PreferencesView>(
              key: Key("PreferencesForPurposes"),
              title: const Text("Purposes"),
              value: PreferencesView.purposes,
              groupValue: _requestedView,
              onChanged: (PreferencesView? value) {
                setState(() {
                  _requestedView = value;
                });
              },
            ),
            RadioListTile<PreferencesView>(
              key: Key("PreferencesForVendors"),
              title: const Text("Vendors"),
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
          key: Key("hidePreferencesAfterAWhile"),
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
          key: Key("isPreferencesVisible"),
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
