import 'package:didomi_sdk_example/widgets/get_disabled_purpose_ids.dart';
import 'package:didomi_sdk_example/widgets/get_enabled_purpose_ids.dart';
import 'package:didomi_sdk_example/widgets/get_required_purpose_ids.dart';
import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/set_user_agree_to_all.dart';
import 'package:didomi_sdk_example/widgets/set_user_disagree_to_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      SampleForPurposeTestsApp(
        // Start app with unique key so app is restarted after tests
        key: UniqueKey(),
      ),
    );

class SampleForPurposeTestsApp extends StatelessWidget {
  SampleForPurposeTestsApp({required Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Purpose Tests",
        home: HomePage(key: key as Key),
      );
}

class HomePage extends StatelessWidget {
  HomePage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        child: ListView(
          key: Key("components_list"),
          children: [
            InitializeSmall(),
            // Actions
            SetUserAgreeToAll(),
            SetUserDisagreeToAll(),
            // Purposes
            GetDisabledPurposeIds(),
            GetEnabledPurposeIds(),
            GetRequiredPurposeIds(),
          ],
        ),
      );
}
