import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/is_ready.dart';
import 'package:didomi_sdk_example/widgets/on_ready.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForInitializeTestsApp());

class SampleForInitializeTestsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Initialize Tests",
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
            IsReady(),
            OnReady(),
          ],
        ),
      );
}
