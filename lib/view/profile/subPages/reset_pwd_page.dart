/*
 * @Description: 重置密码
 * @Author: iamsmiling
 * @Date: 2020-11-12 13:30:32
 * @LastEditTime: 2020-11-13 10:19:59
 */

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class ResetPwdPage extends StatefulWidget {
  final String tel;
  final String code;
  ResetPwdPage({Key key, this.tel, this.code}) : super(key: key);

  @override
  _ResetPwdPageState createState() => _ResetPwdPageState();
}

class _ResetPwdPageState extends State<ResetPwdPage> {
  ValueNotifier<bool> _canForward;
  TextEditingController _passwordController;
  bool _isCypherMode = true;
  @override
  void initState() {
    _canForward = ValueNotifier<bool>(false);
    _passwordController = TextEditingController()
      ..addListener(() {
        _canForward.value = !CommonKit.isNullOrEmpty(_passwordController.text);
      });
    super.initState();
  }

  @override
  void dispose() {
    _canForward?.dispose();
    super.dispose();
  }

  Future resetPwd() {
    String pwd = _passwordController?.text;
    if (CommonKit?.isNullOrEmpty(pwd) == true) {
      ToastKit.showInfo('密码不能为空哦');
      return Future.value(false);
    }
    return OTPService.resetPwd(params: {
      'mobile': widget.tel,
      'mobile_code': widget.code,
      'password': pwd
    }).then((ZYResponse response) {
      if (response?.valid == true) {
        Navigator.of(context)..pop()..pop();
      } else {
        ToastKit.showErrorInfo(response?.message ?? '密码修改失败');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: UIKit.width(40)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpacing(80),
              Text(
                '重置密码',
                textAlign: TextAlign.left,
                style:
                    textTheme.headline6.copyWith(fontWeight: FontWeight.w700),
              ),
              TextField(
                controller: _passwordController,
                // obscureText: ,
                decoration: InputDecoration(
                  hintText: '请输入新密码',
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isCypherMode ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFFCCCCCC),
                      ),
                      onPressed: () {
                        setState(() {
                          _isCypherMode = !_isCypherMode;
                        });
                      }),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFC7C8CB), width: 1)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFC7C8CB), width: 1)),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 32),
                  child: ValueListenableBuilder(
                    valueListenable: _canForward,
                    builder: (BuildContext context, bool flag, _) {
                      return ZYSubmitButton(
                        '完成',
                        resetPwd,
                        isActive: flag,
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
