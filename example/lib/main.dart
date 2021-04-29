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
      title: 'Flutter Demo',
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
  MyHomePage({Key key, this.title}) : super(key: key);

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
  //static const platform = const MethodChannel('flutter_plugin_test');
  String _shouldConsentBeCollected = 'Should consent be collected?.';
  String _platformVersion = 'Unknown';

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

  Future<void> _initialize() async {
    String messageFromNative;
    try {
      final bool result = await DidomiSdk.initialize;
      messageFromNative = 'Response from native: $result';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }
  }

  Future<void> _getShouldConsentBeCollected() async {
    String messageFromNative;
    try {
      final bool result = await DidomiSdk.getShouldConsentBeCollected;
      messageFromNative = 'Response from native: $result';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }

    setState(() {
      _shouldConsentBeCollected = messageFromNative;
    });
  }

  Future<void> _resetDidomi() async {
    String messageFromNative;
    try {
      await DidomiSdk.resetDidomi;
      messageFromNative = 'Native call OK';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }
  }

  Future<void> _showPreferences() async {
    String messageFromNative;
    try {
      await DidomiSdk.showPreferences;
      messageFromNative = 'Native call OK';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Text('Running on: $_platformVersion\n')
            ),
            ElevatedButton(
              child: Text('Initialize SDK'),
              onPressed: _initialize,
            ),
            ElevatedButton(
              child: Text('Should Consent be collected?'),
              onPressed: _getShouldConsentBeCollected,
            ),
            Text(_shouldConsentBeCollected),
            ElevatedButton(
              child: Text('Reset Didomi'),
              onPressed: _resetDidomi,
            ),
            ElevatedButton(
              child: Text('Show Preferences'),
              onPressed: _showPreferences,
            ),
          ],
        ),
      ),
    );
  }
}
