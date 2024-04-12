package com.nesp.sdk.flutter.social

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NespSdkFlutterSocialPlugin */
class NespSdkFlutterSocialPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "nesp_sdk_flutter_social")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "joinQQGroup") {
            val key: String? = call.argument("androidKey")
            if (key == null || key.isEmpty()) {
                result.error(
                    CallMethodResult.Error.ILLEGAL_ARGUMENT.code,
                    "Are you set androidKey on Flutter?",
                    key
                )
                return
            }

            val callMethodResult = joinQQGroup(key)
            if (callMethodResult.isSuccess) {
                result.success(true)
            } else {
                result.error(
                    callMethodResult.error.code,
                    callMethodResult.error.description,
                    "Are you install the new version mobile QQ or TIM on your Android device?"
                )
            }
        } else if (call.method == "joinQQFriend") {
            val qqFriendNumber: String? = call.argument("qqFriendNumber")
            if (qqFriendNumber == null || qqFriendNumber.isEmpty()) {
                result.error(
                    CallMethodResult.Error.ILLEGAL_ARGUMENT.code,
                    "UID is empty, Are you set qqFriendNumber on Flutter?",
                    "qqFriendNumber: $qqFriendNumber",
                )
                return
            }

            val callMethodResult = joinQQFriend(qqFriendNumber)
            if (callMethodResult.isSuccess) {
                result.success(true)
            } else {
                result.error(
                    callMethodResult.error.code,
                    callMethodResult.error.description,
                    "Are you install mobile QQ or TIM on your Android device?"
                )
            }

        } else if (call.method == "openWeiboUser") {
            val uid: String? = call.argument("uid")
            if (uid == null || uid.isEmpty()) {
                result.error(
                    CallMethodResult.Error.ILLEGAL_ARGUMENT.code,
                    "Are you set uid on Flutter?",
                    "uid: $uid"
                )
                return
            }
            val callMethodResult = openWeiboUser(uid)
            if (callMethodResult.isSuccess) {
                result.success(true)
            } else {
                result.error(
                    callMethodResult.error.code,
                    callMethodResult.error.description,
                    "Are you install mobile weibo on your Android device? uid: $uid"
                )
            }

        } else if (call.method == "openOtherApp") {
            val androidPackageName: String? = call.argument("androidPackageName")
            if (androidPackageName == null || androidPackageName.isEmpty()) {
                result.error(
                    CallMethodResult.Error.ILLEGAL_ARGUMENT.code,
                    "Are you set androidPackageName on Flutter?",
                    "androidPackageName: $androidPackageName"
                )
                return
            }

            val androidClassName: String? = call.argument("androidClassName")
            if (androidClassName == null || androidClassName.isEmpty()) {
                result.error(
                    CallMethodResult.Error.ILLEGAL_ARGUMENT.code,
                    "Are you set androidClassName on Flutter?",
                    "androidClassName: $androidClassName"
                )
                return
            }

            try {
                val callMethodResult = openOtherApp(androidPackageName, androidClassName)
                if (callMethodResult.isSuccess) {
                    result.success(true)
                } else {
                    result.error(
                        callMethodResult.error.code,
                        callMethodResult.error.description,
                        "This android device not install $androidPackageName app!"
                    )
                }
            } catch (e: Exception) {
                result.error(
                    CallMethodResult.Error.OPEN_FAILED.code,
                    "An exception occurred when open $androidPackageName.$androidClassName \n ${e.message}",
                    "androidPackageName: $androidPackageName, androidClassName: $androidClassName"
                )
            }

        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun isQqOrTimInstalled(): Boolean {
        return isAppInstalled("com.tencent.mobileqq")
                || isAppInstalled("com.tencent.tim")
    }

    private fun joinQQFriend(qqFriendNumber: String): CallMethodResult {
        val callMethodResult = CallMethodResult()
        if (!isQqOrTimInstalled()) {
            callMethodResult.error = CallMethodResult.Error.APPLICATION_NOT_INSTALLED
            return callMethodResult
        }
        val intent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse("mqqwpa://im/chat?chat_type=wpa&uin=$qqFriendNumber&version=1")
        )
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        try {
            context.startActivity(intent)
            callMethodResult.isSuccess = true
        } catch (e: Exception) {
            callMethodResult.error = CallMethodResult.Error.OPEN_FAILED
        }
        return callMethodResult
    }


    /****************
     *打开QQ群
     * @param key 由官网生成的key
     * @return 返回true表示呼起手Q成功，返回fals表示呼起失败
     */
    private fun joinQQGroup(key: String): CallMethodResult {
        val callMethodResult = CallMethodResult()
        if (!isQqOrTimInstalled()) {
            callMethodResult.error = CallMethodResult.Error.APPLICATION_NOT_INSTALLED
            return callMethodResult
        }

        val intent = Intent()
        intent.data =
            Uri.parse("mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26k%3D$key")
        // 此Flag可根据具体产品需要自定义，如设置，则在加群界面按返回，返回手Q主界面，不设置，按返回会返回到呼起产品界面
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        return try {
            context.startActivity(intent)
            CallMethodResult().apply { isSuccess = true }
        } catch (e: Exception) {
            // 未安装手Q或安装的版本不支持
            CallMethodResult().apply { error = CallMethodResult.Error.OPEN_FAILED }
        }

    }

    /**
     * 打开微博用户
     * @param uidValue 用户ID 打开网页微博,鼠标放在头像下面的关注或粉丝时就能在右下方看见UID
     * NESPTechnology UID=3619635672
     */
    private fun openWeiboUser(uidValue: String): CallMethodResult {
        val weiboPackageName = "com.sina.weibo"
        val callMethodResult = CallMethodResult()
        if (!isAppInstalled(weiboPackageName)) {
            callMethodResult.error = CallMethodResult.Error.APPLICATION_NOT_INSTALLED
            return callMethodResult
        }

        val intent = Intent()
        val componentName =
            ComponentName(weiboPackageName, "com.sina.weibo.page.ProfileInfoActivity")
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        intent.component = componentName
        intent.putExtra("uid", uidValue)
        try {
            context.startActivity(intent)
            callMethodResult.isSuccess = true
        } catch (e: Exception) {
            e.printStackTrace()
            callMethodResult.error = CallMethodResult.Error.OPEN_FAILED
        }
        return callMethodResult
    }

    @Throws(Exception::class)
    private fun openOtherApp(
        androidPackageName: String,
        androidClassName: String
    ): CallMethodResult {
        val callMethodResult = CallMethodResult()

        if (!isAppInstalled(androidPackageName)) {
            callMethodResult.error = CallMethodResult.Error.APPLICATION_NOT_INSTALLED
            return callMethodResult
        }

        val intent = Intent()
        val componentName = ComponentName(androidPackageName, androidClassName)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        intent.component = componentName
        context.startActivity(intent)
        callMethodResult.isSuccess = true
        return callMethodResult
    }


    /**
     * 检查APP是否安装
     *
     * @param packageName 应用包名
     */
    private fun isAppInstalled(packageName: String): Boolean {
        val packageManager: PackageManager = context.packageManager
        packageManager.getInstalledPackages(0).forEach { packageInfo ->
            if (packageInfo.packageName == packageName) {
                return true
            }
        }
        return false
    }

    private class CallMethodResult {
        var isSuccess = false
        var error: Error = Error.NONE

        enum class Error(val code: String, val description: String) {
            NONE("", ""),
            CAN_NOT_OPEN(
                "CAN_NOT_OPEN",
                "Can not open this application, are you set it to whitelist in info.plist?"
            ),
            APPLICATION_NOT_INSTALLED(
                "APPLICATION_NOT_INSTALLED",
                "This application is not installed"
            ),
            OPEN_FAILED("OPEN_FAILED", "Open application is failed"),
            URL_NULL("URL_IS_NULL", "Url is null"),
            ILLEGAL_ARGUMENT("ILLEGAL_ARGUMENT", "The arguments is illegal")
        }
    }

}
