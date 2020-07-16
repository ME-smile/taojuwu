import 'package:flutter/material.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class ResetPwdPage extends StatefulWidget {
  ResetPwdPage({Key key}) : super(key: key);

  @override
  _ResetPwdPageState createState() => _ResetPwdPageState();
}

class _ResetPwdPageState extends State<ResetPwdPage> {
  TextEditingController oldPwdInput;
  TextEditingController newPwdInput;

  @override
  void initState() {
    super.initState();
    oldPwdInput = TextEditingController();
    newPwdInput = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    oldPwdInput?.dispose();

    newPwdInput?.dispose();
  }

  String oldPwd;
  String newPwd;

  bool beforeSendData() {
    oldPwd = oldPwdInput?.text?.trim();
    newPwd = newPwdInput?.text?.trim();

    if (oldPwd?.isNotEmpty != true || newPwd?.isNotEmpty != true) {
      CommonKit.showInfo('密码不能为空哦');
      return false;
    }
    if (oldPwd == newPwd) {
      CommonKit.showInfo('新旧密码不能一样哦');
      return false;
    }
    return true;
  }

  bool canClick = true;
  void resetPwd() {
    if (beforeSendData() == false) return;
    setState(() {
      canClick = false;
    });
    OTPService.resetPwd(
            params: {'old_password': oldPwd, 'new_password': newPwd})
        .then((ZYResponse response) {
      if (response?.valid == true) {
        CommonKit.showSuccessDIYInfo('密码修改成功');
        RouteHandler.goLoginPage(context, replace: true);
      } else {
        CommonKit.showInfo(response?.message ?? '');
      }
    }).catchError((err) {
      return err;
    }).whenComplete(() {
      setState(() {
        canClick = true;
      });
    });
  }

  bool _isOldPwdCypher = true;
  bool _isNewPwdCypher = true;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('重置密码'),
        // actions: <Widget>[
        //   FlatButton(
        //       onPressed: () {
        //         resetPwd();
        //       },
        //       child: Text('完成'))
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: UIKit.width(40)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VSpacing(80),
              Text(
                '重置密码',
                style: textTheme.title.copyWith(fontWeight: FontWeight.w700),
              ),
              VSpacing(30),
              TextField(
                controller: oldPwdInput,
                obscureText: _isOldPwdCypher,
                decoration: InputDecoration(
                  hintText: '请输入旧密码',
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isOldPwdCypher
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFFCCCCCC),
                      ),
                      onPressed: () {
                        setState(() {
                          _isOldPwdCypher = !_isOldPwdCypher;
                        });
                      }),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFC7C8CB), width: .8)),
                ),
              ),
              VSpacing(10),
              TextField(
                controller: newPwdInput,
                obscureText: _isNewPwdCypher,
                decoration: InputDecoration(
                  hintText: '请输入新密码',
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPwdCypher
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFFCCCCCC),
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPwdCypher = !_isNewPwdCypher;
                        });
                      }),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFC7C8CB), width: .8)),
                ),
              ),
              VSpacing(40),
              ZYSubmitButton(
                '重置密码',
                () {
                  resetPwd();
                },
                isActive: canClick,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
