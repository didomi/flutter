import 'package:didomi_sdk_example/widgets/get_user_consent_status_for_purpose.dart';
import 'package:didomi_sdk_example/widgets/get_user_consent_status_for_vendor.dart';
import 'package:didomi_sdk_example/widgets/get_user_consent_status_for_vendor_and_required_purposes.dart';
import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/reset.dart';
import 'package:didomi_sdk_example/widgets/set_user_agree_to_all.dart';
import 'package:didomi_sdk_example/widgets/set_user_disagree_to_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForGetUserConsentTestsApp());

class SampleForGetUserConsentTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Get User Consent Tests",
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
            // Actions
            SetUserAgreeToAll(),
            SetUserDisagreeToAll(),
            Reset(),
            // Purpose
            GetUserConsentStatusForPurpose(),
            // Vendor
            GetUserConsentStatusForVendor(),
            GetUserConsentStatusForVendorAndRequiredPurposes(),
          ],
        ),
      );
}
