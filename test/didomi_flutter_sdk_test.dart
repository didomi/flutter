import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:didomi_flutter_sdk/didomi_flutter_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('didomi_flutter_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DidomiFlutterSdk.platformVersion, '42');
  });
}