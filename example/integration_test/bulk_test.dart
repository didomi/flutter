import 'package:integration_test/integration_test.dart';

import 'initialize_test.dart' as test01;
import 'initialize_with_error_test.dart' as test02;
import 'initialize_with_success_test.dart' as test03;
import 'log_level_test.dart' as test04;
import 'notice_test.dart' as test05;
import 'preferences_test.dart' as test06;
import 'purpose_test.dart' as test07;
import 'setup_ui_test.dart' as test08;
import 'user_consent_for_purpose_test.dart' as test09;
import 'user_consent_for_vendor_and_required_purposes_test.dart' as test10;
import 'user_consent_for_vendor_test.dart' as test11;
import 'user_consent_test.dart' as test12;
import 'vendor_test.dart' as test13;

/// Run All UI tests
// TODO('Doesn't work! - need to reset sdk properly between each scenarios')
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test01.main();
  test02.main();
  test03.main();
  test04.main();
  test05.main();
  test06.main();
  test07.main();
  test08.main();
  test09.main();
  test10.main();
  test11.main();
  test12.main();
  test13.main();
}
