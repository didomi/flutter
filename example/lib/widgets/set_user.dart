import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.SetUserStatus()
class SetUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetUserState();
}

class _SetUserState extends BaseSampleWidgetState<SetUser> {

  bool _withAuthentication = false;
  bool _withSalt = false;

  @override
  String getButtonName() => "Set User";

  @override
  String getActionId() => "setUser";

  @override
  Future<String> callDidomiPlugin() async {

    if (_withAuthentication) {
      String? salt = _withSalt ? "salt" : null;
      await DidomiSdk.setUserWithAuthentication(
          "e3222031-7c45-4f4a-8851-ffd57dbf0a2a",
          "hash-md5",
          "secret_id",
          salt,
          "098f6bcd4621d373cade4e832627b4f6");
    } else {
      await DidomiSdk.setUser("e3222031-7c45-4f4a-8851-ffd57dbf0a2a");
    }
    return "OK";
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
        title: Text("With authentication"),
        key: Key('setUserWithAuth'),
        value: _withAuthentication,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _withAuthentication = newValue;
            });
          }
        },
        controlAffinity:
        ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      CheckboxListTile(
        title: Text("With salt"),
        key: Key('setUserWithSalt'),
        value: _withSalt,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _withSalt = newValue;
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
