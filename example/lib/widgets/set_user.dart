import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/parameters/user_auth_params.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

/// Widget to call DidomiSdk.SetUserStatus()
class SetUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetUserState();
}

class _SetUserState extends BaseSampleWidgetState<SetUser> {

  AuthType _authenticationType = AuthType.userId;
  bool _withSalt = false;
  bool _withExpiration = false;

  @override
  String getButtonName() => "Set User";

  @override
  String getActionId() => "setUser";

  @override
  Future<String> callDidomiPlugin() async {
    String userId = "d13e49f6255c8729cbb201310f49d70d65f365415a67f034b567b7eac962b944eda131376594ef5e23b025fada4e4259e953ceb45ea57a2ced7872c567e6d1fae8dcc3a9772ead783d8513032e77d3fd";
    String secretId = "testsdks-PEap2wBx";
    String? salt = _withSalt ? "test-digest" : null;
    int? expiration = _withExpiration ? 3600 : null;

    switch (_authenticationType) {
      case AuthType.userId:
        await DidomiSdk.setUser(userId);
        break;
      case AuthType.deprecatedAuth:
        await DidomiSdk.setUserWithAuthentication(
            userId,
            "hash-md5",
            secretId,
            salt,
            "test-digest");
        break;
      case AuthType.withHash:
        await DidomiSdk.setUserWithAuthParams(new UserAuthWithHashParams(
            userId,
            "hash-md5",
            secretId,
            "test-digest",
            salt,
            expiration));
        break;
      case AuthType.withEncryption:
        await DidomiSdk.setUserWithAuthParams(new UserAuthWithEncryptionParams(
            userId,
            "aes-256-cbc",
            secretId,
            "3ff223854400259e5592cbb992be93cf",
            expiration));
        break;
      case AuthType.invalid:
        await DidomiSdk.setUserWithAuthParams(new UserAuthWithEncryptionParams(
            userId,
            "hash-md5",
            secretId,
            "3ff223854400259e5592cbb992be93cf",
            expiration));
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
        key: Key("setUserWithAuthDeprecated"),
        title: const Text("Deprecated authentication"),
        value: AuthType.deprecatedAuth,
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
        controlAffinity:
        ListTileControlAffinity.leading, //  <-- leading Checkbox
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
        controlAffinity:
        ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      buildResponseText(getActionId())
    ];
  }
}

enum AuthType { invalid, userId, deprecatedAuth, withHash, withEncryption }

