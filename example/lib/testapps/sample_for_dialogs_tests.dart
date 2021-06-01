import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/setup_ui.dart';
import 'package:didomi_sdk_example/widgets/show_hide_notice.dart';
import 'package:didomi_sdk_example/widgets/show_hide_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForDialogsTestsApp());

class SampleForDialogsTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Dialogs Tests",
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
            ShowHideNotice(),
            ShowHidePreferences(),
            SetupUI(),
          ],
        ),
      );
}
