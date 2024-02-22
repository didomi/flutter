import 'package:didomi_sdk_example/widgets/get_required_vendor_ids.dart';
import 'package:didomi_sdk_example/widgets/get_required_vendors.dart';
import 'package:didomi_sdk_example/widgets/get_vendor.dart';
import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForVendorTestsApp());

class SampleForVendorTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Vendor Tests",
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
            // Vendors
            GetRequiredVendorIds(),
            GetRequiredVendors(),
            GetVendor(),
          ],
        ),
      );
}
