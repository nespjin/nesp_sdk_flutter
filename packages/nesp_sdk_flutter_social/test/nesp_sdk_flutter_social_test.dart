import 'package:flutter_test/flutter_test.dart';
import 'package:nesp_sdk_flutter_social/src/nesp_sdk_flutter_social_platform_interface.dart';
import 'package:nesp_sdk_flutter_social/src/nesp_sdk_flutter_social_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNespSdkFlutterSocialPlatform
    with MockPlatformInterfaceMixin
    implements NespSdkFlutterSocialPlatform {
  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> joinQQFriend({required String qqFriendNumber}) {
    // TODO: implement joinQQFriend
    throw UnimplementedError();
  }

  @override
  Future<bool> joinQQGroup(
      {String androidKey = '', String iosKey = '', required String groupUin}) {
    // TODO: implement joinQQGroup
    throw UnimplementedError();
  }

  @override
  Future<bool> openOtherApp(
      {String androidPackageName = '',
      String androidClassName = '',
      String iosAppUrl = ''}) {
    // TODO: implement openOtherApp
    throw UnimplementedError();
  }

  @override
  Future<bool> openWeiboUser({required String uid}) {
    // TODO: implement openWeiboUser
    throw UnimplementedError();
  }
}

void main() {
  final NespSdkFlutterSocialPlatform initialPlatform =
      NespSdkFlutterSocialPlatform.instance;

  test('$MethodChannelNespSdkFlutterSocial is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNespSdkFlutterSocial>());
  });

  test('getPlatformVersion', () async {
    // NespSdkFlutterSocial nespSdkFlutterSocialPlugin = NespSdkFlutterSocial();
    // MockNespSdkFlutterSocialPlatform fakePlatform = MockNespSdkFlutterSocialPlatform();
    // NespSdkFlutterSocialPlatform.instance = fakePlatform;

    // expect(await nespSdkFlutterSocialPlugin.getPlatformVersion(), '42');
  });
}
