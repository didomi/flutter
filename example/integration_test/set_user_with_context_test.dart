import 'dart:io';

import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk_example/testapps/sample_for_set_user_tests.dart'
    as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/assertion_helper.dart';
import 'util/constants.dart';
import 'util/initialize_helper.dart';
import 'util/scroll_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final platform in ['Android', 'iOS']) {
    group('User context on $platform', () {
      for (final action in [
        'setUserWithContext',
        'setUserWithContextAndSetupUI',
        'setMultiUserWithContext',
        'setMultiUserWithContextAndSetupUI',
      ]) {
        testWidgets('$action completes the native call', (tester) async {
          app.main();
          await tester.pumpAndSettle();
          await InitializeHelper.initialize(
              tester, find.byKey(Key('initializeSmall')));
          await tester.tap(find.byKey(Key('reset')));
          await tester.pumpAndSettle();
          expect(await DidomiSdk.isReady, true);

          final button = find.byKey(Key(action));
          for (var attempt = 0;
              attempt < 12 && button.hitTestable().evaluate().isEmpty;
              attempt++) {
            await scrollDown(tester, Key('components_list'));
          }
          expect(button.hitTestable(), findsOneWidget);
          await tester.tap(button);
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byKey(Key('nativeResponse_$action')));
          await tester.pumpAndSettle();
          assertNativeMessage(action, okMessage);
        }, skip: platform == 'Android' ? !Platform.isAndroid : !Platform.isIOS);
      }
    });
  }
}
