// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nesp_sdk_flutter_social_platform_interface.dart';

/// An implementation of [NespSdkFlutterSocialPlatform] that uses method channels.
class MethodChannelNespSdkFlutterSocial extends NespSdkFlutterSocialPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nesp_sdk_flutter_social');

  @override
  Future<bool> joinQQGroup({
    String androidKey = '',
    String iosKey = '',
    required String groupUin,
  }) async {
    return await methodChannel.invokeMethod<bool?>('joinQQGroup', {
          'androidKey': androidKey,
          'iosKey': iosKey,
          'groupUin': groupUin,
        }) ??
        false;
  }

  @override
  Future<bool> joinQQFriend({required String qqFriendNumber}) async {
    return await methodChannel.invokeMethod<bool?>(
            'joinQQFriend', {'qqFriendNumber': qqFriendNumber}) ??
        false;
  }

  @override
  Future<bool> openWeiboUser({required String uid}) async {
    return await methodChannel
            .invokeMethod<bool?>('openWeiboUser', {'uid': uid}) ??
        false;
  }

  @override
  Future<bool> openOtherApp({
    String androidPackageName = '',
    String androidClassName = '',
    String iosAppUrl = '',
  }) async {
    return await methodChannel.invokeMethod<bool?>('openOtherApp', {
          'androidPackageName': androidPackageName,
          'androidClassName': androidClassName,
          'iosAppUrl': iosAppUrl,
        }) ??
        false;
  }
}
