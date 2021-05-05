import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';

import 'package:didomi_sdk/didomi_sdk.dart';

/* **************************************
 * Base Widgets for Didomi plugin sample
 ************************************** */

abstract class NativeResponseState<T extends StatefulWidget> extends State<T> {
  String _messageFromNative = "--";

  Widget buildResponseText(String key) {
    return Text('Native message: $_messageFromNative\n',
        key: Key('nativeResponse_$key'));
  }

  Future<void> updateMessageFromNative(String messageFromNative) async {
    setState(() {
      _messageFromNative = messageFromNative;
    });
  }
}

/* *************
 * Initialize SDK
 ************* */

class InitializeState extends NativeResponseState<InitializeWidget> {
  TextEditingController _apiKeyController =
      TextEditingController(text: "b5c8560d-77c7-4b1e-9200-954c0693ae1a");

  TextEditingController _noticeIdController =
      TextEditingController(text: "NDQxnJbk");

  TextEditingController _languageController = TextEditingController();

  bool _disableRemoteConfigValue = false;

  Future<void> _initialize() async {
    String messageFromNative;
    try {
      await DidomiSdk.initialize(_apiKeyController.text,
          disableDidomiRemoteConfig: _disableRemoteConfigValue,
          languageCode: _languageController.text,
          noticeId: _noticeIdController.text);
      messageFromNative = 'OK';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }
    updateMessageFromNative(messageFromNative);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
        child: Text('Initialize SDK'),
        onPressed: _initialize,
        key: Key('initialize'),
      ),
      Text('With parameters: \n'),
      TextFormField(
          controller: _apiKeyController,
          decoration: InputDecoration(labelText: 'API Key')),
      TextFormField(
          controller: _noticeIdController,
          decoration: InputDecoration(labelText: 'Notice id')),
      TextFormField(
          controller: _languageController,
          decoration: InputDecoration(labelText: 'Language code')),
      CheckboxListTile(
        title: Text("Disable remote config"),
        key: Key('disableRemoteConfig'),
        value: _disableRemoteConfigValue,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _disableRemoteConfigValue = newValue;
            });
          }
        },
        controlAffinity:
            ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      buildResponseText("initialize")
    ]);
  }
}

class InitializeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InitializeState();
  }
}

/* *************
 * Setup UI
 ************* */

class SetupUIState extends NativeResponseState<SetupUIButton> {
  Future<void> _setupUI() async {
    String messageFromNative;
    try {
      await DidomiSdk.setupUI();
      messageFromNative = 'OK';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }

    updateMessageFromNative(messageFromNative);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
        child: Text('Setup UI'),
        key: Key('setupUI'),
        onPressed: _setupUI,
      ),
      buildResponseText("setupUI")
    ]);
  }
}

class SetupUIButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SetupUIState();
  }
}

/* ****************************
 * Should consent be collected
 **************************** */

class CheckConsentState extends NativeResponseState<CheckConsentButton> {
  Future<void> _getShouldConsentBeCollected() async {
    String messageFromNative;
    try {
      final bool result = await DidomiSdk.shouldConsentBeCollected;
      messageFromNative = 'Result = $result';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }
    updateMessageFromNative(messageFromNative);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
        child: Text('Should consent be collected?'),
        key: Key('shouldConsentBeCollected'),
        onPressed: _getShouldConsentBeCollected,
      ),
      buildResponseText("checkConsent")
    ]);
  }
}

class CheckConsentButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckConsentState();
  }
}

/* ************
 * Reset SDK
 ************ */

class ResetState extends NativeResponseState<ResetButton> {
  Future<void> _resetDidomi() async {
    String messageFromNative;
    try {
      await DidomiSdk.reset();
      messageFromNative = 'OK';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }
    updateMessageFromNative(messageFromNative);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
        child: Text('Reset consents'),
        key: Key('reset'),
        onPressed: _resetDidomi,
      ),
      buildResponseText("reset")
    ]);
  }
}

class ResetButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResetState();
  }
}

/* *****************
 * Show preferences
 ***************** */

class ShowPreferencesState extends NativeResponseState<ShowPreferencesButton> {
  Future<void> _showPreferences() async {
    String messageFromNative;
    try {
      await DidomiSdk.showPreferences();
      messageFromNative = 'OK';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }
    updateMessageFromNative(messageFromNative);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
        child: Text('Show preferences'),
        key: Key('showPreferences'),
        onPressed: _showPreferences,
      ),
      buildResponseText("showPreferences")
    ]);
  }
}

class ShowPreferencesButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShowPreferencesState();
  }
}

/* *****************
 * Is SDK ready
 ***************** */

class IsReadyState extends NativeResponseState<IsReadyButton> {
  Future<void> _getIsReady() async {
    String messageFromNative;
    try {
      final bool result = await DidomiSdk.isReady;
      messageFromNative = 'Result = $result';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }
    updateMessageFromNative(messageFromNative);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
        child: Text('Is Ready?'),
        key: Key('isReady'),
        onPressed: _getIsReady,
      ),
      buildResponseText("isReady")
    ]);
  }
}

class IsReadyButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IsReadyState();
  }
}
