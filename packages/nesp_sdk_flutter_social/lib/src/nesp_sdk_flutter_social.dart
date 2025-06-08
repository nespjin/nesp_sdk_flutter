// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'nesp_sdk_flutter_social_platform_interface.dart';

class NespSdkFlutterSocial {
  const NespSdkFlutterSocial._();

  static const String errorCodeCanNotOpen = 'CAN_NOT_OPEN';
  static const String errorCodeApplicationNotInstalled =
      'APPLICATION_NOT_INSTALLED';
  static const String errorCodeOpenFailed = 'OPEN_FAILED';
  static const String errorCodeUrlNull = 'URL_IS_NULL';
  static const String errorCodeIllegalArgument = 'ILLEGAL_ARGUMENT';

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
