import 'dart:async';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/check_consent.dart';
import 'widgets/get_disabled_purpose_ids.dart';
import 'widgets/get_disabled_vendor_ids.dart';
import 'widgets/get_enabled_purpose_ids.dart';
import 'widgets/get_enabled_vendor_ids.dart';
import 'widgets/get_required_purpose_ids.dart';
import 'widgets/get_required_vendor_ids.dart';
import 'widgets/initialize.dart';
import 'widgets/is_ready.dart';
import 'widgets/on_ready.dart';
import 'widgets/reset.dart';
import 'widgets/sdk_events_logger.dart';
import 'widgets/set_log_level.dart';
import 'widgets/set_user_agree_to_all.dart';
import 'widgets/set_user_disagree_to_all.dart';
import 'widgets/setup_ui.dart';
import 'widgets/show_preferences.dart';

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
  MyApp({required Key key}) : super(key: key);

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
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            key: Key("components_list"),
            children: [
              Text('Running on: $_platformVersion\n',
                  textAlign: TextAlign.center),
              IsReady(),
              OnReady(),
              OnError(),
              Initialize(),
              SetupUI(),
              CheckConsent(),
              Reset(),
              ShowPreferences(),
              SetLogLevel(),
              SetUserAgreeToAll(),
              SetUserDisagreeToAll(),
              // Purposes
              Text('Purposes:'),
              GetDisabledPurposeIds(),
              GetEnabledPurposeIds(),
              GetRequiredPurposeIds(),
              // Vendors
              Text('Vendors:'),
              GetDisabledVendorIds(),
              GetEnabledVendorIds(),
              GetRequiredVendorIds(),
              // Events
              SdkEventsLogger(),
            ],
          ),
        ),
      ),
    );
  }
}
