import 'package:didomi_sdk_example/widgets/initialize.dart';
import 'package:didomi_sdk_example/widgets/is_ready.dart';
import 'package:didomi_sdk_example/widgets/on_ready.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() =>
    runApp(
      SampleForInitializeCustomTestsApp(
        // Start app with unique key so app is restarted after tests
        key: UniqueKey(),
      ),
    );

class SampleForInitializeCustomTestsApp extends StatelessWidget {
  SampleForInitializeCustomTestsApp({required Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        title: "Initialize Tests",
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
            IsReady(),
            OnReady(),
            Initialize(),
          ],
        ),
      );
}
