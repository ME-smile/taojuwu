import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/config/err_message.dart';
import 'package:taojuwu/event_bus/events/login_event.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';

class LoginViewModel with ChangeNotifier {
  TextEditingController phoneController;
  TextEditingController pwdController;
  TextEditingController smsController;

  LoginViewModel()
      : phoneController = TextEditingController(),
        pwdController = TextEditingController(),
        smsController = TextEditingController();
  bool hasSendSms = false;
  String get tel {
    return phoneController?.text ?? '';
  }

  String get pwd {
    return pwdController?.text ?? '';
  }

  String get sms => smsController?.text ?? '';

  //电话号码是否有效
  bool get isValidTel {
    bool flag = RegexUtil.isMobileExact(phoneController?.text);
    return flag;
  }

  //密码是否为空
  bool get isPwdEmpty {
    return CommonKit.isNullOrEmpty(pwdController?.text);
  }

  // 登录模式 0代表手机登录 1代表密码登录
  bool isPwdMode = false;

  /*
  *
  *@author iamsmiling
  *@create_time 2020/9/24 4:52 PM
  *@description 修改登录模式--->0
  *@params
  *@return
  */
  void changeLoginMode(int mode) {
    isPwdMode = mode == 0 ? true : false;
    notifyListeners();
  }

  /*
    * @Author: iamsmiling
    * @description:登录功能
    * @param : 账号密码
    * @return {type}
    * @Date: 2020-09-25 09:11:44
    */
  Future login(BuildContext ctx) {
    if (!isPwdMode) {
      if (!isValidTel) {
        ToastKit.showErrorInfo(ErrMessage.INVALID_TEL);
        return Future.value(false);
      }
      if (isPwdEmpty) {
        ToastKit.showErrorInfo(ErrMessage.EMPTY_PWD);
        return Future.value(false);
      }
      return OTPService.loginByPwd(params).then((ZYResponse response) {
        if (response?.valid == true) {
          saveInfo(response, ctx);
        }
      });
    } else {
      if (!hasSendSms) {
        ToastKit.showInfo('请先获取验证码哦');
        return Future.value(false);
      }
      if (sms?.isNotEmpty != true) {
        ToastKit.showErrorInfo('验证码不能为空哦');
        return Future.value(false);
      }
      return OTPService.loginBySms(params: {'mobile': tel, 'mobile_code': sms})
          .then((ZYResponse response) {
        if (response?.valid == true) {
          saveInfo(response, ctx);
        } else {
          ToastKit.showInfo(response?.message);
        }
      }).catchError((err) {
        print('验证短信验证码失败');
      });
    }
  }

  void saveInfo(ZYResponse response, BuildContext ctx) {
    UserProvider userProvider = Provider.of(ctx, listen: false);
    userProvider.userInfo.saveUserInfo(response.data);
    // 触发登录，舒信token
    Application.eventBus.fire(LoginEvent(1));
    RouteHandler.goHomePage(ctx);
  }

  //释放资源
  @override
  void dispose() {
    phoneController?.dispose();
    pwdController?.dispose();
    smsController?.dispose();
    super.dispose();
  }

  Map<String, dynamic> get params => {'username': tel, 'password': pwd};
}
