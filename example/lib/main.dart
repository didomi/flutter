import 'package:didomi_sdk_example/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';

import 'package:didomi_sdk/didomi_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Didomi Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _shouldConsentBeCollected = 'Should consent be collected?.';
  String _platformVersion = 'Unknown';
  String _messageFromNative = '--';

  TextEditingController _apiKeyController =
      TextEditingController(text: "b5c8560d-77c7-4b1e-9200-954c0693ae1a");

  TextEditingController _noticeIdController =
      TextEditingController(text: "NDQxnJbk");

  TextEditingController _languageController = TextEditingController();

  bool _disableRemoteConfigValue = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await DidomiSdk.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> updateMessageFromNative(String messageFromNative) async {
    setState(() {
      _messageFromNative = messageFromNative;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Center(
          child: ListView(
            children: [
              Text('Running on: $_platformVersion\n'),
              IsReadyButton(),
              InitializeWidget(),
              SetupUIButton(),
              CheckConsentButton(),
              ResetButton(),
              ShowPreferencesButton(),
            ],
          ),
        ),
      ),
    );
  }
}
