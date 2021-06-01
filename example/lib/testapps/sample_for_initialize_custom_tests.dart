import 'package:didomi_sdk_example/widgets/initialize.dart';
import 'package:didomi_sdk_example/widgets/is_ready.dart';
import 'package:didomi_sdk_example/widgets/on_ready.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForInitializeCustomTestsApp());

class SampleForInitializeCustomTestsApp extends StatelessWidget {
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
            IsReady(),
            OnReady(),
            Initialize(),
          ],
        ),
      );
}
