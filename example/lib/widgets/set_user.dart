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
  bool _withSynchronizedUsers = false;

  bool? _isUnderage = null;

  @override
  String getButtonName() => "Set User";

  @override
  String getActionId() => "setUser";

  @override
  Future<String> callDidomiPlugin() async {
    String userId = "d13e49f6255c8729cbb201310f49d70d65f365415a67f034b567b7eac962b944eda131376594ef5e23b025fada4e4259e953ceb45ea57a2ced7872c567e6d1fae8dcc3a9772ead783d8513032e77d3fd";
    String userId1 = "d13e49f6255c8729cbb201310f49d70d65f365415a67f034b567b7eac962b944eda131376594ef5e23b025fada4e4259e953ceb45ea57a2ced7872c567e6d1fae8dcc3a9772ead783d8513032e77d3f1";
    String userId2 = "d13e49f6255c8729cbb201310f49d70d65f365415a67f034b567b7eac962b944eda131376594ef5e23b025fada4e4259e953ceb45ea57a2ced7872c567e6d1fae8dcc3a9772ead783d8513032e77d3f2";
    String secretId = "testsdks-PEap2wBx";
    String initializationVector = "3ff223854400259e5592cbb992be93cf";
    String? salt = _withSalt ? "test-digest" : null;
    int? expiration = _withExpiration ? 3600 : null;
    bool setUserAndSetupUI = _withSetupUI;
    bool hasSynchronizedUsers = _withSynchronizedUsers;
    bool? isUnderage = _isUnderage;
    List<UserAuthParams>? synchronizedUsers;

    switch (_authenticationType) {
      case AuthType.clearUser:
        await DidomiSdk.clearUser();
        break;
      case AuthType.userId:
        if (setUserAndSetupUI) {
          await DidomiSdk.setUserAndSetupUI(userId, isUnderage);
        } else {
          await DidomiSdk.setUser(userId, isUnderage);
        }
        break;
      case AuthType.withHash:
        if (hasSynchronizedUsers) {
          synchronizedUsers = [
            new UserAuthWithHashParams(userId1, "hash-md5", secretId, "test-digest", salt, expiration),
            new UserAuthWithEncryptionParams(userId2, "aes-256-cbc", secretId, initializationVector, expiration)
          ];
        }
        if (setUserAndSetupUI) {
          await DidomiSdk.setUserWithAuthParamsAndSetupUI(
              new UserAuthWithHashParams(userId, "hash-md5", secretId, "test-digest", salt, expiration),
              synchronizedUsers,
              isUnderage
          );
        } else {
          await DidomiSdk.setUserWithAuthParams(
              new UserAuthWithHashParams(userId, "hash-md5", secretId, "test-digest", salt, expiration),
              synchronizedUsers,
              isUnderage
          );
        }
        break;
      case AuthType.withEncryption:
        if (hasSynchronizedUsers) {
          synchronizedUsers = [
            new UserAuthWithHashParams(userId1, "hash-md5", secretId, "test-digest", salt, expiration),
            new UserAuthWithEncryptionParams(userId2, "aes-256-cbc", secretId, initializationVector, expiration)
          ];
        }
        if (setUserAndSetupUI) {
          await DidomiSdk.setUserWithAuthParamsAndSetupUI(
              new UserAuthWithEncryptionParams(userId, "aes-256-cbc", secretId, initializationVector, expiration),
              synchronizedUsers,
              isUnderage
          );
        } else {
          await DidomiSdk.setUserWithAuthParams(
              new UserAuthWithEncryptionParams(userId, "aes-256-cbc", secretId, initializationVector, expiration),
              synchronizedUsers,
              isUnderage
          );
        }
        break;
      case AuthType.invalid:
        if (hasSynchronizedUsers) {
          synchronizedUsers = [
            new UserAuthWithHashParams(userId1, "error", secretId, "test-digest-fail", salt, expiration),
            new UserAuthWithEncryptionParams(userId2, "hash-md6", secretId, initializationVector, expiration)
          ];
        }
        if (setUserAndSetupUI) {
          await DidomiSdk.setUserWithAuthParamsAndSetupUI(
              new UserAuthWithEncryptionParams(userId, "hash-md6", secretId, initializationVector, expiration),
              synchronizedUsers,
              isUnderage
          );
        } else {
          await DidomiSdk.setUserWithAuthParams(
              new UserAuthWithEncryptionParams(userId, "hash-md6", secretId, initializationVector, expiration),
              synchronizedUsers,
              isUnderage
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
      CheckboxListTile(
        title: Text("With synchronized users"),
        key: Key('withSynchronizedUsers'),
        value: _withSynchronizedUsers,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _withSynchronizedUsers = newValue;
            });
          }
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Is Underage:'),
            SizedBox(width: 10),
            DropdownButton<bool?>(
              key: Key("isUnderage"),
              value: _isUnderage,
              onChanged: (bool? newValue) {
                setState(() {
                  _isUnderage = newValue;
                });
              },
              items: <bool?>[true, false, null].map<DropdownMenuItem<bool?>>((bool? value) {
                return DropdownMenuItem<bool?>(
                  value: value,
                  child: Text(value == null ? 'null' : value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      buildResponseText(getActionId())
    ];
  }
}

enum AuthType { invalid, userId, withHash, withEncryption, clearUser }
