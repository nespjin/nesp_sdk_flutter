// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nesp_sdk_flutter_social/nesp_sdk_flutter_social.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  /// QQ好友号码
  static const String qqFriendNumber = "2021785540";

  /// QQ群Android平台Key
  String? qqGroupAndroidKey;

  /// QQ群号码
  static const String qqGroupUin = '428741525';

  /// QQ群IOS平台Key
  String? qqGroupIosKey;

  /// 微博UID
  static const String weiboUid = "3619635672";

  /// 其他应用的包名
  static const String otherAppAndroidPkgName = "com.nesp.movie";

  /// 其他应用的Activity类名
  static const String otherAppAndroidClsName =
      "com.nesp.movie.ui.activity.WelcomeActivity";

  bool _isCalledApp = false;
  String _callAppMessage = 'not called app';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nesp Social example'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'isCalledApp:$_isCalledApp\n\n'
                'callAppMessage:\n$_callAppMessage',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NespButton(
                    text: "加好友\n$qqFriendNumber",
                    onPressed: joinQQFriend,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: NespButton(
                      text: "加群\n$qqGroupUin",
                      onPressed: () {
                        qqGroupAndroidKey = 'olKPAVYzuXrYIIJfRoHKYQTVJDqDW0O7';
                        qqGroupIosKey =
                            '707e806c7f0192ef834b79229784166688c8df0bfd6b7fab25003a6212c7417c';
                        joinQQGroup();
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: NespButton(
                        text: "Join QQ group\nwithout key",
                        onPressed: () {
                          qqGroupAndroidKey = null;
                          qqGroupIosKey = null;
                          joinQQGroup();
                        },
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NespButton(
                  text: "打开微博用户",
                  onPressed: openWeiboUser,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NespButton(
                    text: "打开其他应用",
                    onPressed: openOtherApp,
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  void openWeiboUser() async {
    bool isCalledWeibo;
    String callWeiboMessage;
    try {
      final isSuccess = await NespSdkFlutterSocial.openWeiboUser(uid: weiboUid);

      isCalledWeibo = isSuccess;
      callWeiboMessage = "weiboUid:$weiboUid";
    } on PlatformException catch (e) {
      isCalledWeibo = false;
      callWeiboMessage = 'Exception When Call weibo\n'
          'Code:${e.code}\n'
          'Message:${e.message}\n'
          'Details:${e.details}';
    }

    if (!mounted) return;

    setState(() {
      _isCalledApp = isCalledWeibo;
      _callAppMessage = callWeiboMessage;
    });
  }

  Future<void> joinQQFriend() async {
    bool isCalledQQ;
    String callQQMessage;

    try {
      isCalledQQ = await NespSdkFlutterSocial.joinQQFriend(
        qqFriendNumber: qqFriendNumber,
      );
      callQQMessage = 'qqFriendNumber: $qqFriendNumber';
    } on PlatformException catch (e) {
      isCalledQQ = false;
      callQQMessage = 'Exception When Join QQ Friend\n'
          'Code:${e.code}\n'
          'Message:${e.message}\n'
          'Details:${e.details}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isCalledApp = isCalledQQ;
      _callAppMessage = callQQMessage;
    });
  }

  Future<void> joinQQGroup() async {
    bool isCalledQQ;
    String callQQMessage;

    try {
      isCalledQQ = await NespSdkFlutterSocial.joinQQGroup(
        androidKey: qqGroupAndroidKey ?? '',
        groupUin: qqGroupUin,
        iosKey: qqGroupIosKey ?? '',
      );

      callQQMessage = 'qqGroupAndroidKey: $qqGroupAndroidKey'
          'qqGroupUin:$qqGroupUin'
          'qqGroupIosKey:$qqGroupIosKey';
    } on PlatformException catch (e) {
      isCalledQQ = false;
      callQQMessage = 'Exception When Join QQ Group\n'
          'Code:${e.code}\n'
          'Message:${e.message}\n'
          'Details:${e.details}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isCalledApp = isCalledQQ;
      _callAppMessage = callQQMessage;
    });
  }

  Future<void> openOtherApp() async {
    bool isCalledOtherApp;
    String callOtherAppMessage = '';

    try {
      isCalledOtherApp = await NespSdkFlutterSocial.openOtherApp(
        androidPackageName: otherAppAndroidPkgName,
        androidClassName: otherAppAndroidClsName,
        // Open WIFI settings
        iosAppUrl: "alipay://",
      );

      if (Platform.isAndroid) {
        callOtherAppMessage = 'androidPackageName: $otherAppAndroidPkgName\n'
            'androidClassName:$otherAppAndroidClsName';
      } else if (Platform.isIOS) {
        callOtherAppMessage = 'UrlScheme: alipay://';
      }
    } on PlatformException catch (e) {
      isCalledOtherApp = false;
      callOtherAppMessage = 'Exception When Call Other APP\n'
          'Code:${e.code}\n'
          'Message:${e.message}\n'
          'Details:${e.details}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isCalledApp = isCalledOtherApp;
      _callAppMessage = callOtherAppMessage;
    });
  }
}

class NespButton extends StatelessWidget {
  const NespButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 2,
      height: 50,
      textColor: Colors.white,
      color: Colors.blue,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
