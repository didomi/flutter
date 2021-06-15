import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/reset.dart';
import 'package:didomi_sdk_example/widgets/set_user_agree_to_all.dart';
import 'package:didomi_sdk_example/widgets/set_user_disagree_to_all.dart';
import 'package:didomi_sdk_example/widgets/set_user_status.dart';
import 'package:didomi_sdk_example/widgets/set_user_status_globally.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForSetUserConsentTestsApp());

class SampleForSetUserConsentTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Set User Consent Tests",
        home: HomePage(),
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        child: ListView(
          key: Key("components_list"),
          children: [
            InitializeSmall(),
            // Actions
            SetUserAgreeToAll(),
            SetUserDisagreeToAll(),
            SetUserStatusGlobally(),
            SetUserStatus(),
            Reset(),
          ],
        ),
      );
}
