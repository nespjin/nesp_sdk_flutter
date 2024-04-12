import Flutter
import UIKit

public class NespSdkFlutterSocialPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "nesp_sdk_flutter_social", binaryMessenger: registrar.messenger())
        let instance = NespSdkFlutterSocialPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let callMethodName = call.method
        
        if callMethodName == "joinQQGroup" {
            
            guard let args = call.arguments as? [String : String] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "args is nil or empty, are you set arguments on Flutter",
                                         details: call.arguments))
                return
            }
            
            guard let groupUin = args["groupUin"] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "groupUin is not set",
                                         details: call.arguments))
                return
            }
            
            guard let iosKey = args["iosKey"] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "iosKey is not set",
                                         details: call.arguments))
                return
            }
            
            let callResult = joinQQGroup(groupUin: groupUin, iosKey: iosKey)
            if callResult.isSuccess {
                result(true)
            } else {
                result(FlutterError.init(code: callResult.error.rawValue,
                                         message: callResult.error.description,
                                         details: "groupUin:\(groupUin)\niosKey:\(iosKey)"))
            }
            
            
        } else if callMethodName == "joinQQFriend" {
            
            guard let args = call.arguments as? [String : String] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "args is nil or empty, are you set arguments on Flutter",
                                         details: call.arguments))
                return
            }
            
            guard let qqFriendNumber = args["qqFriendNumber"] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "qqFriendNumber is not set",
                                         details: call.arguments))
                return
            }
            
            let callResult = joinQQFriend(qqFriendNumber: qqFriendNumber)
            if callResult.isSuccess {
                result(true)
            } else {
                result(FlutterError.init(code: callResult.error.rawValue,
                                         message: callResult.error.description,
                                         details: "qqFriendNumber:\(qqFriendNumber)"))
            }
            
        } else if callMethodName == "openWeiboUser" {
            
            guard let args = call.arguments as? [String : String] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "args is nil or empty, are you set arguments on Flutter",
                                         details: call.arguments))
                return
            }
            
            guard let uid = args["uid"] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "uid is not set",
                                         details: call.arguments))
                return
            }
            
            let callResult = openWeiboUser(uid: uid)
            if callResult.isSuccess {
                result(true)
            } else {
                result(FlutterError.init(code: callResult.error.rawValue,
                                         message: callResult.error.description,
                                         details: "uid:\(uid)"))
            }
            
        } else if callMethodName == "openOtherApp" {
            
            guard let args = call.arguments as? [String : String] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "args is nil or empty, are you set arguments on Flutter",
                                         details: call.arguments))
                return
            }
            
            guard let iosAppUrl = args["iosAppUrl"] else {
                result(FlutterError.init(code: CallMethodResult.Error.illegalArgument.rawValue,
                                         message: "iosAppUrl is not set",
                                         details: call.arguments))
                return
            }
            
            let callResult = openOtherApp(iosAppUrl: iosAppUrl)
            if callResult.isSuccess {
                result(true)
            } else {
                result(FlutterError.init(code: callResult.error.rawValue,
                                         message: callResult.error.description,
                                         details: "iosAppUrl:\(iosAppUrl)"))
            }
            
        } else {
            //Not implement
        }
    }
    
    private func joinQQGroup(groupUin:String,iosKey:String)->CallMethodResult{
        let callMethodResult = CallMethodResult()
        
        let urlString = "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=\(groupUin)&key=\(iosKey)&card_type=group&source=external&jump_from=webapi"
        let url = URL.init(string:urlString)
        if url == nil {
            callMethodResult.error = CallMethodResult.Error.urlNil
            return callMethodResult
        }
        
        if !isQQInstalled() {
            callMethodResult.error = CallMethodResult.Error.applicationNotInstalled
            return callMethodResult
        }
        
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!,options: [:], completionHandler: nil)
                callMethodResult.isSuccess = true
                return callMethodResult
            } else {
                callMethodResult.isSuccess = UIApplication.shared.openURL(url!)
                if !callMethodResult.isSuccess {
                    callMethodResult.error = CallMethodResult.Error.openFailed
                }
                return callMethodResult
            }
        } else {
            callMethodResult.error = CallMethodResult.Error.canNotOpen
            return callMethodResult
        }
    }
    
    private func joinQQFriend(qqFriendNumber:String)->CallMethodResult{
        let callMethodResult = CallMethodResult()
        
        let urlString = "mqqwpa://im/chat?chat_type=wpa&uin=\(qqFriendNumber)&version=1&src_type=web"
        
        let url = URL.init(string:urlString)
        if url == nil {
            callMethodResult.error = CallMethodResult.Error.urlNil
            return callMethodResult
        }
        
        if !isQQInstalled() {
            callMethodResult.error = CallMethodResult.Error.applicationNotInstalled
            return callMethodResult
        }
        
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!,options: [:], completionHandler: nil)
                callMethodResult.isSuccess = true
                return callMethodResult
            } else {
                callMethodResult.isSuccess = UIApplication.shared.openURL(url!)
                if !callMethodResult.isSuccess {
                    callMethodResult.error = CallMethodResult.Error.openFailed
                }
                return callMethodResult
            }
        } else {
            callMethodResult.error = CallMethodResult.Error.canNotOpen
            return callMethodResult
        }
        
    }
    
    
    /// 打开微博用户
    ///
    /// - Parameter uid: 用户ID 打开网页微博,鼠标放在头像下面的关注或粉丝时就能在右下方看见UID
    /// - returns Call success or not
    ///
    private func openWeiboUser(uid:String)->CallMethodResult{
        let callMethodResult = CallMethodResult()
        
        let urlString = "sinaweibo://userinfo?uid=\(uid)"
        let url = URL.init(string: urlString)
        
        if url == nil {
            callMethodResult.error = CallMethodResult.Error.urlNil
            return callMethodResult
        }
        
        if !isWeiboInstalled() {
            callMethodResult.error = CallMethodResult.Error.applicationNotInstalled
            return callMethodResult
        }
        
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                callMethodResult.isSuccess = true
                return callMethodResult
            } else {
                callMethodResult.isSuccess = UIApplication.shared.openURL(url!)
                if !callMethodResult.isSuccess {
                    callMethodResult.error = CallMethodResult.Error.openFailed
                }
                return callMethodResult
            }
        } else {
            callMethodResult.error = CallMethodResult.Error.canNotOpen
            return callMethodResult
        }
    }
    
    private func openOtherApp(iosAppUrl:String)->CallMethodResult{
        let callMethodResult = CallMethodResult()
        
        let url = URL.init(string: iosAppUrl)
        
        if url == nil {
            callMethodResult.error = CallMethodResult.Error.urlNil
            return callMethodResult
        }
        
        if !isApplicationInstalled(uriScheme: iosAppUrl) {
            callMethodResult.error = CallMethodResult.Error.applicationNotInstalled
            return callMethodResult
        }
        
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                callMethodResult.isSuccess = true
                return callMethodResult
            } else {
                callMethodResult.isSuccess = UIApplication.shared.openURL(url!)
                if !callMethodResult.isSuccess {
                    callMethodResult.error = CallMethodResult.Error.openFailed
                }
                return callMethodResult
            }
        } else {
            callMethodResult.error = CallMethodResult.Error.canNotOpen
            return callMethodResult
        }
    }
    
    private func isWeiboInstalled()->Bool{
        return isApplicationInstalled(uriScheme: "sinaweibo://")
    }
    
    private func isQQInstalled()->Bool{
        return isApplicationInstalled(uriScheme: "mqqapi://") || isApplicationInstalled(uriScheme: "mqq://")
    }
    
    private func isApplicationInstalled(uriScheme:String)->Bool{
        let url = URL.init(string: uriScheme)
        if url == nil {
            return false
        }
        return UIApplication.shared.canOpenURL(url!)
    }
    
    class CallMethodResult {
        var isSuccess = false
        
        var error:Error = Error.none
        
        enum Error : String {
            case none = ""
            case canNotOpen = "CAN_NOT_OPEN"
            case applicationNotInstalled = "APPLICATION_NOT_INSTALLED"
            case openFailed = "OPEN_FAILED"
            case urlNil = "URL_IS_NULL"
            case illegalArgument = "ILLEGAL_ARGUMENT"
            
            var description: String {
                switch(self) {
                case .none:
                    return ""
                case .canNotOpen:
                    return "Can not open this application, are you set it to whitelist in info.plist?"
                case .applicationNotInstalled:
                    return "This application is not installed"
                case .openFailed:
                    return "Open application is failed"
                case .urlNil:
                    return "Url is nil"
                case .illegalArgument:
                    return "The arguments is illegal"
                }
            }
        }
    }
    
}
