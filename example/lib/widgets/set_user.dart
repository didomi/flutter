import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/parameters/user_auth_params.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.SetUser()
class SetUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetUserState();
}

class _SetUserState extends BaseSampleWidgetState<SetUser> {
  AuthType _authenticationType = AuthType.clearUser;
  bool _withSalt = false;
  bool _withExpiration = false;
  bool _withSetupUI = false;

  @override
  String getButtonName() => "Set User";

  @override
  String getActionId() => "setUser";

  @override
  Future<String> callDidomiPlugin() async {
    String userId = "d13e49f6255c8729cbb201310f49d70d65f365415a67f034b567b7eac962b944eda131376594ef5e23b025fada4e4259e953ceb45ea57a2ced7872c567e6d1fae8dcc3a9772ead783d8513032e77d3fd";
    String secretId = "testsdks-PEap2wBx";
    String initializationVector = "3ff223854400259e5592cbb992be93cf";
    String? salt = _withSalt ? "test-digest" : null;
    int? expiration = _withExpiration ? 3600 : null;
    bool setUserAndSetupUI = _withSetupUI;

    switch (_authenticationType) {
      case AuthType.clearUser:
        await DidomiSdk.clearUser();
        break;
      case AuthType.userId:
        if (setUserAndSetupUI) {
          await DidomiSdk.setUserAndSetupUI(userId);
        } else {
          await DidomiSdk.setUser(userId);
        }
        break;
      case AuthType.withHash:
        if (setUserAndSetupUI) {
          await DidomiSdk.setUserWithAuthParamsAndSetupUI(new UserAuthWithHashParams(userId, "hash-md5", secretId, "test-digest", salt, expiration));
        } else {
          await DidomiSdk.setUserWithAuthParams(new UserAuthWithHashParams(userId, "hash-md5", secretId, "test-digest", salt, expiration));
        }
        break;
      case AuthType.withEncryption:
        if (setUserAndSetupUI) {
          await DidomiSdk.setUserWithAuthParamsAndSetupUI(
              new UserAuthWithEncryptionParams(userId, "aes-256-cbc", secretId, initializationVector, expiration));
        } else {
          await DidomiSdk.setUserWithAuthParams(
              new UserAuthWithEncryptionParams(userId, "aes-256-cbc", secretId, initializationVector, expiration));
        }
        break;
      case AuthType.invalid:
        if (setUserAndSetupUI) {
          await DidomiSdk.setUserWithAuthParamsAndSetupUI(
              new UserAuthWithEncryptionParams(userId, "hash-md6", secretId, initializationVector, expiration)
          );
        } else {
          await DidomiSdk.setUserWithAuthParams(
              new UserAuthWithEncryptionParams(userId, "hash-md6", secretId, initializationVector, expiration)
          );
        }
        break;
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
      RadioListTile<AuthType>(
        key: Key("clearUser"),
        title: const Text("Clear user"),
        value: AuthType.clearUser,
        groupValue: _authenticationType,
        onChanged: (AuthType? value) {
          if (value != null) {
            setState(() {
              _authenticationType = value;
            });
          }
        },
      ),
      RadioListTile<AuthType>(
        key: Key("setUserWithId"),
        title: const Text("User id only"),
        value: AuthType.userId,
        groupValue: _authenticationType,
        onChanged: (AuthType? value) {
          if (value != null) {
            setState(() {
              _authenticationType = value;
            });
          }
        },
      ),
      RadioListTile<AuthType>(
        key: Key("setUserAuthWithHash"),
        title: const Text("Authentication with hash"),
        value: AuthType.withHash,
        groupValue: _authenticationType,
        onChanged: (AuthType? value) {
          if (value != null) {
            setState(() {
              _authenticationType = value;
            });
          }
        },
      ),
      RadioListTile<AuthType>(
        key: Key("setUserAuthWithEncryption"),
        title: const Text("Authentication with encryption"),
        value: AuthType.withEncryption,
        groupValue: _authenticationType,
        onChanged: (AuthType? value) {
          if (value != null) {
            setState(() {
              _authenticationType = value;
            });
          }
        },
      ),
      RadioListTile<AuthType>(
        key: Key("setUserWithInvalidParams"),
        title: const Text("Invalid auth params"),
        value: AuthType.invalid,
        groupValue: _authenticationType,
        onChanged: (AuthType? value) {
          if (value != null) {
            setState(() {
              _authenticationType = value;
            });
          }
        },
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
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      CheckboxListTile(
        title: Text("With expiration"),
        key: Key('setUserWithExpiration'),
        value: _withExpiration,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _withExpiration = newValue;
            });
          }
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      CheckboxListTile(
        title: Text("With setupUI"),
        key: Key('setUserAndSetupUI'),
        value: _withSetupUI,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _withSetupUI = newValue;
            });
          }
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      buildResponseText(getActionId())
    ];
  }
}

enum AuthType { invalid, userId, withHash, withEncryption, clearUser }
