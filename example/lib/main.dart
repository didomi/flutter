import 'package:didomi_sdk_example/widgets/check_consent.dart';
import 'package:didomi_sdk_example/widgets/initialize.dart';
import 'package:didomi_sdk_example/widgets/is_ready.dart';
import 'package:didomi_sdk_example/widgets/on_ready.dart';
import 'package:didomi_sdk_example/widgets/reset.dart';
import 'package:didomi_sdk_example/widgets/sdk_events_logger.dart';
import 'package:didomi_sdk_example/widgets/setup_ui.dart';
import 'package:didomi_sdk_example/widgets/show_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:didomi_sdk/didomi_sdk.dart';

void main() {
  _startApp();
}

void _startApp() {
  runApp(
    MyApp(
      // Start app with unique key so app is restarted after tests
      key: UniqueKey(),
    ),
  );
}

class MyApp extends StatelessWidget {

  MyApp({
    required Key key
  })  : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Didomi Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // TODO Remove this when dev is complete
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await DidomiSdk.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Didomi Flutter Demo'),
      ),
      body: Material(
        child: Center(
          child: ListView(
            key: Key("components_list"),
            children: [
              Text('Running on: $_platformVersion\n'),
              IsReady(),
              OnReady(),
              Initialize(),
              SetupUI(),
              CheckConsent(),
              Reset(),
              ShowPreferences(),
              SdkEventsLogger(),
            ],
          ),
        ),
      ),
    );
  }
}
