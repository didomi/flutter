import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/chain_disable_purpose_transactions.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/chain_disable_vendor_transactions.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/chain_enable_purpose_transactions.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/chain_enable_vendor_transactions.dart';
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
            ChainEnablePurposeTransactions(),
            ChainDisablePurposeTransactions(),
            ChainEnableVendorTransactions(),
            ChainDisableVendorTransactions(),
          ],
        ),
      );
}
