import 'package:didomi_sdk_example/widgets/get_purpose.dart';
import 'package:didomi_sdk_example/widgets/get_required_purpose_ids.dart';
import 'package:didomi_sdk_example/widgets/get_required_purposes.dart';
import 'package:didomi_sdk_example/widgets/initialize_small.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForPurposeTestsApp());

class SampleForPurposeTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Purpose Tests",
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
            // Purposes
            GetRequiredPurposeIds(),
            GetRequiredPurposes(),
            GetPurpose()
          ],
        ),
  );
}
