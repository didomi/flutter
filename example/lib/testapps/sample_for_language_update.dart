import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/update_selected_language.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForLanguageUpdateTestsApp());

class SampleForLanguageUpdateTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Language Tests",
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
            UpdateSelectedLanguage(),
          ],
        ),
      );
}
