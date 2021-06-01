import 'package:didomi_sdk_example/widgets/get_disabled_vendor_ids.dart';
import 'package:didomi_sdk_example/widgets/get_enabled_vendor_ids.dart';
import 'package:didomi_sdk_example/widgets/get_required_vendor_ids.dart';
import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/set_user_agree_to_all.dart';
import 'package:didomi_sdk_example/widgets/set_user_disagree_to_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() =>
    runApp(
      SampleForVendorTestsApp(
        // Start app with unique key so app is restarted after tests
        key: UniqueKey(),
      ),
    );

class SampleForVendorTestsApp extends StatelessWidget {
  SampleForVendorTestsApp({required Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        title: "Vendor Tests",
        home: HomePage(key: key as Key),
      );
}

class HomePage extends StatelessWidget {
  HomePage({required Key key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) =>
      Material(
        child: ListView(
          key: Key("components_list"),
          controller: scrollController,
          children: [
            InitializeSmall(),
            // Actions
            SetUserAgreeToAll(),
            SetUserDisagreeToAll(),
            // Vendors
            GetDisabledVendorIds(),
            GetEnabledVendorIds(),
            GetRequiredVendorIds(),
          ],
        ),
      );
}
