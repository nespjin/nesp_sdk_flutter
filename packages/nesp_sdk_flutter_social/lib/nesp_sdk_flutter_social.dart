import 'nesp_sdk_flutter_social_platform_interface.dart';

class NespSdkFlutterSocial {
  const NespSdkFlutterSocial._();

  static Future<bool> joinQQGroup({
    String androidKey = '',
    String iosKey = '',
    required String groupUin,
  }) async {
    return await NespSdkFlutterSocialPlatform.instance.joinQQGroup(
      androidKey: androidKey,
      iosKey: iosKey,
      groupUin: groupUin,
    );
  }

  static Future<bool> joinQQFriend({required String qqFriendNumber}) async {
    return await NespSdkFlutterSocialPlatform.instance
        .joinQQFriend(qqFriendNumber: qqFriendNumber);
  }

  static Future<bool> openWeiboUser({required String uid}) async {
    return await NespSdkFlutterSocialPlatform.instance.openWeiboUser(uid: uid);
  }

  static Future<bool> openOtherApp({
    String androidPackageName = '',
    String androidClassName = '',
    String iosAppUrl = '',
  }) async {
    return await NespSdkFlutterSocialPlatform.instance.openOtherApp(
      androidPackageName: androidPackageName,
      androidClassName: androidClassName,
      iosAppUrl: iosAppUrl,
    );
  }
}
