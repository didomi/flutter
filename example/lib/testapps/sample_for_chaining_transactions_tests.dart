import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/disable_purpose_chain_transactions.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/disable_vendor_chain_transactions.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/enable_purpose_chain_transactions.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/enable_vendor_chain_transactions.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForChainingTransactionsTestsApp());

class SampleForChainingTransactionsTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Get Transactions for Chaining Tests",
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
            EnablePurposeChainTransactions(),
            DisablePurposeChainTransactions(),
            EnableVendorChainTransactions(),
            DisableVendorChainTransactions(),
          ],
        ),
      );
}
