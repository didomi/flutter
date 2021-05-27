import 'package:didomi_sdk_example/widgets/get_text.dart';
import 'package:didomi_sdk_example/widgets/get_translated_text.dart';
import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/update_selected_language.dart';
import 'package:didomi_sdk_example/widgets/webview_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      SampleForTextTestsApp(
        // Start app with unique key so app is restarted after tests
        key: UniqueKey(),
      ),
    );

class SampleForTextTestsApp extends StatelessWidget {
  SampleForTextTestsApp({required Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Text Tests",
        home: HomePage(key: key as Key),
      );
}

class HomePage extends StatelessWidget {
  HomePage({required Key key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => Material(
        child: ListView(
          key: Key("components_list"),
          controller: scrollController,
          children: [
            InitializeSmall(),
            // Get text
            GetText(),
            WebviewStrings(),
          ],
        ),
      );
}
