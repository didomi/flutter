import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForGetUserConsentTestsApp());

class SampleForGetUserConsentTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Get Current User Consent Tests",
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
          ],
        ),
      );
}
