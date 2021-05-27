import 'package:flutter/material.dart';

import 'apps/sample_for_user_consent_tests.dart';
import 'sdk_tests_base.dart' as base;

void main() {
  base.main();
  _startApp();
}

void _startApp() {
  runApp(
    SampleForUserConsentTestsApp(
      // Start app with unique key so app is restarted after tests
      key: UniqueKey(),
    ),
  );
}
