import 'package:flutter/material.dart';

import 'apps/sample_for_purpose_tests.dart';
import 'sdk_tests_base.dart' as base;

void main() {
  base.main();
  _startApp();
}

void _startApp() {
  runApp(
    SampleForPurposeTestsApp(
      // Start app with unique key so app is restarted after tests
      key: UniqueKey(),
    ),
  );
}
