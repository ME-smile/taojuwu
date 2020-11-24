import 'package:flutter/material.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/send_sms_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class ForgetPwdPage extends StatefulWidget {
  ForgetPwdPage({Key key}) : super(key: key);

  @override
  _ForgetPwdPageState createState() => _ForgetPwdPageState();
}

class _ForgetPwdPageState extends State<ForgetPwdPage> {
  TextEditingController telInput;
  TextEditingController smsInput;

  //是否可以进行下一步
  ValueNotifier<bool> canForward;

  @override
  void initState() {
    super.initState();
    telInput = TextEditingController();
    smsInput = TextEditingController();
    canForward = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    super.dispose();
    telInput?.dispose();
    smsInput?.dispose();
    canForward?.dispose();
  }

  Future sendSms() {
    return OTPService.sendSms(params: {'mobile': telInput?.text, 'type': 2})
        .then((ZYResponse response) {
      if (response?.valid == true) {
        canForward.value = true;
        ToastKit.showInfo('验证码发送成功');
      } else {
        canForward.value = true;
        ToastKit.showInfo(response?.message ?? '');
      }
    }).catchError((err) {
      print('发送验证码失败');

      canForward.value = false;
      throw Exception('发送验证码失败');
    });
  }

  Future validateSms() {
    String tel = telInput?.text;
    String code = smsInput?.text;
    if (CommonKit.isNullOrEmpty(code)) {
      ToastKit.showInfo('请输入验证码');
      return Future.value(false);
    }
    return OTPService.validateSms(
        params: {'mobile': tel, 'type': 3, 'mobile_code': code}).then((_) {
      print('发送验证码成功');
      canForward.value = true;
      RouteHandler.goResetPwdPage(context, tel: tel, code: code);
    }).catchError((err) {
      print('发送验证码失败');
      canForward.value = false;
      ToastKit.showErrorInfo('验证码发送失败!');

      throw Exception('发送验证码失败');
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: UIKit.width(40)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VSpacing(80),
              Text(
                '找回密码',
                style:
                    textTheme.headline6.copyWith(fontWeight: FontWeight.w700),
              ),
              VSpacing(30),
              TextField(
                controller: telInput,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: '请输入手机号',
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFC7C8CB), width: .5)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFC7C8CB), width: .5)),
                    icon: Container(
                      child: Text(
                        '+86',
                        style: TextStyle(fontSize: 14),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFFC7C8CB), width: .5))
                          // border: Border.fromBorderSide(BorderSide(color: ))
                          ),
                    )),
              ),
              VSpacing(10),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 16),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    TextField(
                      controller: smsInput,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '请输入验证码',
                        // suffixIcon: SendSmsButton(
                        //   telPhoneController: telInput,
                        //   callback: sendSms,
                        // ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFC7C8CB), width: .8)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFC7C8CB), width: .8)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: -2,
                      child: SendSmsButton(
                        telPhoneController: telInput,
                        callback: sendSms,
                      ),
                    )
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: canForward,
                builder: (BuildContext context, bool flag, Widget child) {
                  return Container(
                      margin: EdgeInsets.only(top: 38),
                      child: ZYSubmitButton(
                        '下一步',
                        flag ? validateSms : null,
                        horizontalMargin: 0,
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
