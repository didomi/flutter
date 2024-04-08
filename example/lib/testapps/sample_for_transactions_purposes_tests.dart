import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/disable_purpose_chain_transactions.dart';
import 'package:didomi_sdk_example/widgets/transactions/chains/enable_purpose_chain_transactions.dart';
import 'package:didomi_sdk_example/widgets/transactions/disable_purpose_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/disable_purposes_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/enable_purpose_transaction.dart';
import 'package:didomi_sdk_example/widgets/transactions/enable_purposes_transaction.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForTransactionsPurposesTestsApp());

class SampleForTransactionsPurposesTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Get Transactions for Purposes Tests",
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
            EnablePurposeTransaction(),
            DisablePurposeTransaction(),
            EnablePurposesTransaction(),
            DisablePurposesTransaction(),
            EnablePurposeChainTransactions(),
            DisablePurposeChainTransactions()
          ],
        ),
      );
}
