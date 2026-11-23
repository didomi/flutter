import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/parameters/didomi_user_parameters.dart';
import 'package:didomi_sdk/parameters/user_auth_params.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('didomi_sdk');
  final calls = <MethodCall>[];
  final auth = UserAuthWithoutParams('test-user');
  final contexts = <String, DidomiUserContext?>{
    'omitted': null,
    'full': DidomiUserContext(
        attributes: {'plan': 'premium'},
        variables: {'segment': 'test'},
        age: 18,
        isLoggedIn: true),
    'zero and false': DidomiUserContext(age: 0, isLoggedIn: false),
    'empty': DidomiUserContext(),
    'empty maps': DidomiUserContext(attributes: {}, variables: {}),
  };
  final expectedContexts = <String, Map<String, dynamic>?>{
    'omitted': null,
    'full': {
      'attributes': {'plan': 'premium'},
      'variables': {'segment': 'test'},
      'age': 18,
      'isLoggedIn': true
    },
    'zero and false': {'age': 0, 'isLoggedIn': false},
    'empty': {},
    'empty maps': {'attributes': {}, 'variables': {}},
  };

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  for (final entry in contexts.entries) {
    testWidgets('single-user channel preserves ${entry.key} context',
        (tester) async {
      final parameters =
          DidomiUserParameters(userAuth: auth, userContext: entry.value);
      await DidomiSdk.setUserWithParameters(parameters);
      expect(calls, hasLength(1));
      expect(calls.single.method, 'setUserWithParameters');
      final json = calls.single.arguments['jsonDidomiUserParameters'] as Map;
      expect(json['userAuth'], {'id': 'test-user'});
      expect(json.containsKey('userContext'), entry.value != null);
      expect(json['userContext'], expectedContexts[entry.key]);
    });
  }

  testWidgets('native errors propagate to the caller', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'setUser', message: 'rejected');
    });
    final parameters =
        DidomiUserParameters(userAuth: auth, userContext: DidomiUserContext());
    await expectLater(DidomiSdk.setUserWithParameters(parameters),
        throwsA(isA<PlatformException>()));
  });
}
