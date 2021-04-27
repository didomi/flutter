import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const platform = const MethodChannel('didomi.io/sdk');
  String _shouldConsentBeCollected = 'Should consent be collected?.';

  Future<void> _getShouldConsentBeCollected() async {
    String messageFromNative;
    try {
      final bool result = await platform.invokeMethod('getShouldConsentBeCollected');
      messageFromNative = 'Response from native: $result';
    } on PlatformException catch (e) {
      messageFromNative = "Failed: '${e.message}'.";
    }

    setState(() {
      _shouldConsentBeCollected = messageFromNative;
    });
}

  Future<void> _resetDidomi() async {
    String message;
    try {
      final int result = await platform.invokeMethod('resetDidomi');
      message = 'Response from native: $result';
    } on PlatformException catch (e) {
      message = "Failed: '${e.message}'.";
    }
  }

  Future<void> _showPreferences() async {
    String message;
    try {
      final int result = await platform.invokeMethod('showPreferences');
      message = 'Response from native: $result';
    } on PlatformException catch (e) {
      message = "Failed: '${e.message}'.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
