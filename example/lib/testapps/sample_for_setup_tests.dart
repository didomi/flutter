import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/set_log_level.dart';
import 'package:didomi_sdk_example/widgets/setup_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForSetupUITestsApp());

class SampleForSetupUITestsApp extends StatelessWidget {
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
            SetupUI(),
            SetLogLevel(),
          ],
        ),
      );
}
