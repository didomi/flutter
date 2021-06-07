import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/log_level.dart';
import 'package:didomi_sdk_example/events_helper.dart';
import 'package:didomi_sdk_example/widgets/get_text.dart';
import 'package:didomi_sdk_example/widgets/get_translated_text.dart';
import 'package:didomi_sdk_example/widgets/set_user.dart';
import 'package:didomi_sdk_example/widgets/update_selected_language.dart';
import 'package:didomi_sdk/events/event_listener.dart';
import 'package:flutter/material.dart';

import 'events_helper.dart';
import 'widgets/check_consent.dart';
import 'widgets/get_disabled_purpose_ids.dart';
import 'widgets/get_disabled_vendor_ids.dart';
import 'widgets/get_enabled_purpose_ids.dart';
import 'widgets/get_enabled_vendor_ids.dart';
import 'widgets/get_required_purpose_ids.dart';
import 'widgets/get_required_vendor_ids.dart';
import 'widgets/get_text.dart';
import 'widgets/get_translated_text.dart';
import 'widgets/get_user_consent_status_for_purpose.dart';
import 'widgets/get_user_consent_status_for_vendor.dart';
import 'widgets/get_user_consent_status_for_vendor_and_required_purposes.dart';
import 'widgets/get_user_legitimate_interest_status_for_purpose.dart';
import 'widgets/get_user_legitimate_interest_status_for_vendor.dart';
import 'widgets/get_user_legitimate_interest_status_for_vendor_and_required_purposes.dart';
import 'widgets/get_user_status_for_vendor.dart';
import 'widgets/initialize.dart';
import 'widgets/is_ready.dart';
import 'widgets/on_error.dart';
import 'widgets/on_ready.dart';
import 'widgets/reset.dart';
import 'widgets/sdk_events_logger.dart';
import 'widgets/set_log_level.dart';
import 'widgets/set_user.dart';
import 'widgets/set_user_agree_to_all.dart';
import 'widgets/set_user_disagree_to_all.dart';
import 'widgets/set_user_status.dart';
import 'widgets/setup_ui.dart';
import 'widgets/show_hide_notice.dart';
import 'widgets/show_hide_preferences.dart';
import 'widgets/update_selected_language.dart';
import 'widgets/webview_strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Didomi Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: "Flutter Demo Home Page"),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title}) : super();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _sdkEvents = "";
  EventsHelper eventsHelper = EventsHelper();
  EventListener noticeListener = EventListener();

  // Keep track if notice is visible or not
  bool didomiNoticeVisible = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    DidomiSdk.setLogLevel(LogLevel.verbose);

    noticeListener.onShowNotice = () => setState(() {
          didomiNoticeVisible = true;
        });
    noticeListener.onHideNotice = () => setState(() {
          didomiNoticeVisible = false;
        });
    DidomiSdk.addEventListener(noticeListener);

    eventsHelper.uiCallback = (eventDescription) => onEvent(eventDescription);
  }

  void onEvent(String eventDescription) {
    final snackBar = SnackBar(content: Text(eventDescription));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      _sdkEvents += "\n- $eventDescription";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Didomi Flutter Demo"),
      ),
      body: AbsorbPointer(
        // When notice is visible, prevent user from interacting with the rest of the application (iOS bug)
        absorbing: didomiNoticeVisible,
        child: Material(
          child: Center(
            child: ListView(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              key: Key("components_list"),
              controller: scrollController,
              children: [
                // SDK setup
                Text("Setup:"),
                IsReady(),
                OnReady(),
                OnError(),
                SetLogLevel(),
                Initialize(),
                SetUser(),
                // UI related features
                Text("UI:"),
                SetupUI(),
                ShowHideNotice(),
                ShowHidePreferences(),
                // Consents
                Text("Consents:"),
                CheckConsent(),
                Reset(),
                SetUserAgreeToAll(),
                SetUserDisagreeToAll(),
                SetUserStatus(),
                // Purposes
                Text("Purposes:"),
                GetDisabledPurposeIds(),
                GetEnabledPurposeIds(),
                GetRequiredPurposeIds(),
                GetUserConsentStatusForPurpose(),
                GetUserLegitimateInterestStatusForPurpose(),
                // Vendors
                Text("Vendors:"),
                GetDisabledVendorIds(),
                GetEnabledVendorIds(),
                GetRequiredVendorIds(),
                GetUserConsentStatusForVendor(),
                GetUserConsentStatusForVendorAndRequiredPurposes(),
                GetUserLegitimateInterestStatusForVendor(),
                GetUserLegitimateInterestStatusForVendorAndRequiredPurposes(),
                GetUserStatusForVendor(),
                // Languages,
                Text("Languages:"),
                UpdateSelectedLanguage(),
                GetText(),
                GetTranslatedText(),
                // Webviews
                Text("Webviews:"),
                WebviewStrings(),
                // Events
                SdkEventsLogger(_sdkEvents),
              ],
            ),
          ),
        ),
      )
    );
  }
}
