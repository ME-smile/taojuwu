import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/send_sms_button.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';
// import 'package:taojuwu/widgets/zy_assetImage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  FocusNode _phoneNode;
  FocusNode _pwdNode;
  FocusNode _smsNode;
  UserProvider _userProvider;
  bool _isPwdMode = false;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _phoneNode = FocusNode();
    _pwdNode = FocusNode();
    _smsNode = FocusNode();
  }

  void unfocus() {
    _phoneNode?.unfocus();
    _pwdNode?.unfocus();
    _smsNode?.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController?.dispose();
    _pwdController?.dispose();
    _smsController?.dispose();
    _phoneNode?.dispose();
    _pwdNode?.dispose();
    _smsNode?.dispose();
    // _isPwdMode?.dispose();
  }

  void afterLogin(Map<String, dynamic> json) {
    _userProvider.userInfo.saveUserInfo(json);
  }

  void showPrivacy(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '使用协议',
              textAlign: TextAlign.center,
            ),
            content: Container(
                // decoration: ,
                color: themeData.primaryColor,
                // margin: EdgeInsets.symmetric(
                //   horizontal: UIKit.width(50),
                // ),
                child: SingleChildScrollView(
                  child: Text(Constants.PRIVACY),
                )),
          );
        });
  }

  void loginBySms(BuildContext context) {
    unfocus();
    String tel = _phoneController.text;
    String code = _smsController.text;
    if (tel.trim().isEmpty) {
      return CommonKit.showInfo('手机号不能为空哦');
    }
    if (code.trim().isEmpty) {
      return CommonKit.showInfo('验证码不能为空哦');
    }
    OTPService.loginBySms(context, {'mobile': tel, 'mobile_code': code})
        .then((ZYResponse response) {
      if (response.valid) {
        _phoneController.text = '';
        _smsController.text = '';
        RouteHandler.goHomePage(context);
      } else {
        // CommonKit.toast(context, '${response.message ?? "登录失败"}');
      }
    }).catchError((err) => err);
  }

  void loginByPwd(BuildContext context) {
    String tel = _phoneController.text;
    String pwd = _pwdController.text;
    if (tel.trim().isEmpty) {
      return CommonKit.showInfo('手机号不能为空哦');
    }

    if (RegexUtil.isTel(tel)) {
      return CommonKit.showInfo('请输入正确的手机号');
    }
    if (pwd.trim().isEmpty) {
      return CommonKit.showInfo('密码不能为空哦');
    }
    OTPService.loginByPwd(context, {'username': tel, 'password': pwd})
        .then((ZYResponse response) {
      if (response.valid) {
        // CommonKit.toast(context, '登录成功');
        _phoneController.text = '';
        _pwdController.text = '';
        afterLogin(response.data);
        RouteHandler.goHomePage(context);
      } else {
        // CommonKit.toast(context, '${response.message ?? "登录失败"}');
      }
    }).catchError((err) => err);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: theme.scaffoldBackgroundColor,
      // ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          VSpacing(220),
          Text(
            '欢迎回家',
            textAlign: TextAlign.center,
            style: textTheme.headline5,
          ),
          VSpacing(10),
          Text(
            '登陆后可购买商品或者查看更多内容',
            style: textTheme.subtitle2.copyWith(
              fontSize: UIKit.sp(28),
            ),
            textAlign: TextAlign.center,
          ),
          VSpacing(60),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: UIKit.width(70), vertical: UIKit.height(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  child: Text(
                    '手机号码登录',
                    style: textTheme.subtitle1,
                  ),
                  onTap: () {
                    if (!_isPwdMode) {
                      setState(() {
                        _isPwdMode = !_isPwdMode;
                      });
                    }
                  },
                ),
                InkWell(
                  child: Text(
                    '密码登录',
                    style: textTheme.subtitle1,
                  ),
                  onTap: () {
                    if (_isPwdMode) {
                      setState(() {
                        _isPwdMode = !_isPwdMode;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: LoginPageIndicatorPainter(
                triangleW: 5.0,
                pointX: _isPwdMode ? w * 0.25 - 20.0 : w * 0.75 + 5.0,
                width: w),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(50)),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _phoneController,
                  focusNode: _phoneNode,
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
                                    color: theme.dividerColor, width: .5))
                            // border: Border.fromBorderSide(BorderSide(color: ))
                            ),
                      )),
                ),
                VSpacing(20),
                _isPwdMode
                    ? TextField(
                        controller: _smsController,
                        focusNode: _smsNode,
                        decoration: InputDecoration(
                            hintText: '请输入验证码',
                            suffixIcon: SendSmsButton(
                              callback: () async {
                                String tel = _phoneController.text;
                                if (tel.trim().isEmpty) {
                                  return CommonKit.showInfo('手机号不能为空哦');
                                }
                                if (!RegexUtil.isMobileExact(tel)) {
                                  return CommonKit.showInfo('请输入正确的手机号');
                                }
                                return OTPService.getSms(
                                        context, {'mobile': tel})
                                    .then((ZYResponse response) {
                                  if (response.valid) {
                                    CommonKit.showToast('验证码发送成功,请注意查收');
                                  } else {
                                    CommonKit.showToast('验证码发送失败,请稍后重试');
                                  }
                                }).catchError((err) => err);
                              },
                            )),
                      )
                    : TextField(
                        obscureText: true,
                        controller: _pwdController,
                        focusNode: _pwdNode,
                        decoration: InputDecoration(
                            hintText: '请输入密码',
                            suffixIcon: FlatButton(
                                onPressed: () {
                                  RouteHandler.goForgetPwdPage(context);
                                },
                                child: Text('忘记密码'))),
                      ),
              ],
            ),
          ),
          VSpacing(50),
          // ZYRaisedButton(text, callback)
          ZYSubmitButton('登录', () {
            CommonKit.debounce(() {
              // if(_isPwdMode){
              //   loginBySms(context);
              // }else{

              // }
              loginByPwd(context);
            }, 500);
          }),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(50)),
            child: Text.rich(TextSpan(
                text: '登陆即代表同意淘居屋',
                style: textTheme.caption,
                children: [
                  TextSpan(text: '  '),
                  WidgetSpan(
                      child: InkWell(
                    onTap: () {
                      showPrivacy(context);
                    },
                    child: Text('用户协议',
                        style: textTheme.caption
                            .copyWith(color: textTheme.bodyText1.color)),
                  )),
                ])),
          ),
          VSpacing(100),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text('第三方账号登入  '),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
          //       child: ZYAssetImage(
          //         'wechat.png',
          //         width: UIKit.width(80),
          //         height: UIKit.height(80),
          //       ),
          //     ),
          //     ZYAssetImage('qq.png',
          //         width: UIKit.width(80), height: UIKit.height(80)),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class LoginPageIndicatorPainter extends CustomPainter {
  final double triangleW;
  final double pointX;
  final double width;

  LoginPageIndicatorPainter({this.triangleW, this.pointX, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Color(0xff666666)
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 0), Offset(pointX - triangleW, 0), paint);

    canvas.drawLine(
        Offset(pointX - triangleW, 0), Offset(pointX, -triangleW), paint);
    canvas.drawLine(
        Offset(pointX, -triangleW), Offset(pointX + 2 * triangleW, 0), paint);

    canvas.drawLine(Offset(width, 0), Offset(pointX + 2 * triangleW, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
