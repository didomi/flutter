import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/setup_ui.dart';
import 'package:didomi_sdk_example/widgets/show_hide_notice.dart';
import 'package:didomi_sdk_example/widgets/show_hide_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() =>
    runApp(
      SampleForDialogsTestsApp(
        // Start app with unique key so app is restarted after tests
        key: UniqueKey(),
      ),
    );

class SampleForDialogsTestsApp extends StatelessWidget {
  SampleForDialogsTestsApp({required Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        title: "Dialogs Tests",
        home: HomePage(key: key as Key),
      );
}

class HomePage extends StatelessWidget {
  HomePage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Material(
        child: ListView(
          key: Key("components_list"),
          children: [
            InitializeSmall(),
            ShowHideNotice(),
            ShowHidePreferences(),
            SetupUI(),
          ],
        ),
      );
}
