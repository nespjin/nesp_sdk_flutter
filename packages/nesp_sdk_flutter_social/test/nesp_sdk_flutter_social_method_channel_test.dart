import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nesp_sdk_flutter_social/src/nesp_sdk_flutter_social_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNespSdkFlutterSocial platform =
      MethodChannelNespSdkFlutterSocial();
  const MethodChannel channel = MethodChannel('nesp_sdk_flutter_social');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    // expect(await platform.getPlatformVersion(), '42');
  });
}
