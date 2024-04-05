import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/transactions/disable_purpose_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/disable_purposes_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/disable_vendor_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/disable_vendors_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/enable_purpose_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/enable_purposes_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/enable_vendor_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/enable_vendors_transaction.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForTransactionsVendorsTestsApp());

class SampleForTransactionsVendorsTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Get Transactions for Vendors Tests",
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
            // Transactions
            Text("Transactions:"),
            EnableVendorTransaction(),
            DisableVendorTransaction(),
            EnableVendorsTransaction(),
            DisableVendorsTransaction()
          ],
        ),
      );
}
