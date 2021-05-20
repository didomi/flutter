import 'package:flutter/material.dart';

import 'apps/sample_for_user_consent_for_vendor_tests.dart';
import 'sdk_tests_base.dart' as base;

void main() {
  base.main();
  _startApp();
}

void _startApp() {
  runApp(
    SampleForUserConsentForVendorTestsApp(
      // Start app with unique key so app is restarted after tests
      key: UniqueKey(),
    ),
  );
}
