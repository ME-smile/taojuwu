import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/send_sms_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

class ForgetPwdPage extends StatefulWidget {
  ForgetPwdPage({Key key}) : super(key: key);

  @override
  _ForgetPwdPageState createState() => _ForgetPwdPageState();
}

class _ForgetPwdPageState extends State<ForgetPwdPage> {
  TextEditingController telInput;
  TextEditingController smsInput;

  @override
  void initState() {
    super.initState();
    smsInput = TextEditingController();
    smsInput = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    telInput?.dispose();
    smsInput?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                // resetPwd();
              },
              child: Text('下一步'))
        ],
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
                style: textTheme.title.copyWith(fontWeight: FontWeight.w700),
              ),
              VSpacing(30),
              TextField(
                controller: telInput,
                decoration: InputDecoration(
                    hintText: '请输入手机号',
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFC7C8CB), width: .1)),
                    icon: Container(
                      child: Text('+86'),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: themeData.dividerColor, width: .5))
                          // border: Border.fromBorderSide(BorderSide(color: ))
                          ),
                    )),
              ),
              VSpacing(10),
              TextField(
                controller: smsInput,
                decoration: InputDecoration(
                  hintText: '请输入验证码',
                  suffixIcon: SendSmsButton(
                    callback: () async {
                      String tel = telInput.text;
                      if (tel.trim().isEmpty) {
                        return CommonKit.showInfo('手机号不能为空哦');
                      }
                      if (!RegexUtil.isMobileExact(tel)) {
                        return CommonKit.showInfo('请输入正确的手机号');
                      }
                      return OTPService.getSms(context, {'mobile': tel})
                          .then((ZYResponse response) {
                        if (response.valid) {
                          CommonKit.showToast('验证码发送成功,请注意查收');
                        } else {
                          CommonKit.showToast('验证码发送失败,请稍后重试');
                        }
                      }).catchError((err) => err);
                    },
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFC7C8CB), width: .8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
