import 'package:didomi_sdk_example/widgets/get_text.dart';
import 'package:didomi_sdk_example/widgets/get_translated_text.dart';
import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/update_selected_language.dart';
import 'package:didomi_sdk_example/widgets/webview_strings.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForTextTestsApp());

class SampleForTextTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Text Tests",
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
            // Get text
            GetText(),
            WebviewStrings(),
            // Change language
            UpdateSelectedLanguage(),
            // Get text
            GetTranslatedText(),
          ],
        ),
      );
}
