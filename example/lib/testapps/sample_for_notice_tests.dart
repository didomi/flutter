import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/show_hide_notice.dart';
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
          ],
        ),
      );
}
