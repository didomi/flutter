import 'apps/sample_for_initialize_tests.dart';
import 'sdk_tests_base.dart' as base;
import 'package:flutter/material.dart';

void main() {
  base.main();
  _startApp();
}

void _startApp() {
  runApp(
    SampleForInitializeTestsApp(
      // Start app with unique key so app is restarted after tests
      key: UniqueKey(),
    ),
  );
}