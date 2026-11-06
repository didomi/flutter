import 'package:didomi_sdk_example/widgets/get_applicable_regulation.dart';
import 'package:didomi_sdk_example/widgets/get_applicable_regulation_configuration.dart';
import 'package:didomi_sdk_example/widgets/initialize_custom_regulation.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForCustomRegulationTestsApp());

class SampleForCustomRegulationTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Custom Regulation Tests",
        home: HomePage(),
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        child: ListView(
          key: Key("components_list"),
          children: [
            InitializeCustomRegulation(),
            GetApplicableRegulation(),
            GetApplicableRegulationConfiguration(),
          ],
        ),
      );
}
