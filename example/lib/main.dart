import 'package:didomi_sdk/events/event_listener.dart';
import 'package:didomi_sdk_example/widgets/get_text.dart';
import 'package:didomi_sdk_example/widgets/get_translated_text.dart';
import 'package:didomi_sdk_example/widgets/update_selected_language.dart';

import 'widgets/webview_strings.dart';
import 'widgets/check_consent.dart';
import 'widgets/initialize.dart';
import 'widgets/is_ready.dart';
import 'widgets/on_ready.dart';
import 'widgets/reset.dart';
import 'widgets/sdk_events_logger.dart';
import 'widgets/setup_ui.dart';
import 'widgets/show_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:didomi_sdk/didomi_sdk.dart';

import 'widgets/on_error.dart';

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

  String _sdkEvents = "";

  EventListener listener = EventListener();

  @override
  void initState() {
    super.initState();
    initPlatformState();

    print("Create Logger");
    listener.onReady = () {
      onEvent("SDK Ready");
    };
    listener.onError = (message) {
      onEvent("Error : $message");
    };
    listener.onShowNotice = () {
      onEvent("Notice displayed");
    };
    listener.onHideNotice = () {
      onEvent("Notice hidden");
    };

    DidomiSdk.addEventListener(listener);
  }

  void onEvent(String eventDescription) {
    print("Received an event -- $eventDescription");
    final snackBar = SnackBar(content: Text(eventDescription));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      _sdkEvents += "\n- $eventDescription";
    });
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
              OnError(),
              Initialize(),
              SetupUI(),
              CheckConsent(),
              Reset(),
              ShowPreferences(),
              UpdateSelectedLanguage(),
              GetText(),
              GetTranslatedText(),
              WebviewStrings(),
              SdkEventsLogger(_sdkEvents),
            ],
          ),
        ),
      ),
    );
  }
}
