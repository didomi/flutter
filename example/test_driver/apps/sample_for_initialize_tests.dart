import 'package:didomi_sdk_example/widgets/initialize.dart';
import 'package:didomi_sdk_example/widgets/is_ready.dart';
import 'package:didomi_sdk_example/widgets/on_error.dart';
import 'package:didomi_sdk_example/widgets/on_ready.dart';
import 'package:didomi_sdk_example/widgets/setup_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SampleForInitializeTestsApp extends StatelessWidget {
  SampleForInitializeTestsApp({required Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Initialize Tests",
        home: HomePage(),
      );
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        child: ListView(
          key: Key("components_list"),
          children: [
            IsReady(),
            OnReady(),
            OnError(),
            Initialize(),
            SetupUI(),
          ],
        ),
      );
}
