import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/send_sms_button.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

import 'widgets/login_page_indicator.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneController;
  TextEditingController _pwdController;
  TextEditingController _smsController;

  UserProvider _userProvider;
  bool _isPwdMode = false;
  double startX = 0;
  String get tel => _phoneController?.text;

  bool get isValidTel {
    return RegexUtil.isMobileExact(tel);
  }

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _phoneController = TextEditingController();
    _pwdController = TextEditingController();
    _smsController = TextEditingController();
    initView();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController?.dispose();
    _pwdController?.dispose();
    _smsController?.dispose();
    // _isPwdMode?.dispose();
  }

  void afterLogin(Map<String, dynamic> json) {
    _userProvider.userInfo.saveUserInfo(json);
  }

  void initView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox box1 = context1.findRenderObject();
      RenderBox box2 = context2.findRenderObject();
      Offset position1 = box1.localToGlobal(Offset.zero);
      Offset position2 = box2.localToGlobal(Offset.zero);
      Size size1 = box1.size;
      Size size2 = box2.size;
      startX1 = position1.dx + (size1.width / 2);
      startX2 = position2.dx + (size2.width / 2);
      setState(() {});
      //
      if (Application.hasAgree == false) {
        return showTip();
      }
    });
  }

  void unfocus() {
    FocusManager.instance.primaryFocus.unfocus();
  }

  bool canClick = true;
  void loginByPwd(BuildContext context) {
    String tel = _phoneController.text;
    String pwd = _pwdController.text;
    if (tel.trim().isEmpty) {
      return ToastKit.showInfo('手机号不能为空哦');
    }

    if (RegexUtil.isTel(tel)) {
      return ToastKit.showInfo('请输入正确的手机号');
    }
    if (pwd.trim().isEmpty) {
      return ToastKit.showInfo('密码不能为空哦');
    }
    setState(() {
      canClick = false;
    });
    OTPService.loginByPwd({'username': tel, 'password': pwd})
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
        })
        .catchError((err) => err)
        .whenComplete(() {
          setState(() {
            canClick = true;
          });
        });
  }

  void showTip() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        '温馨提示',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        '欢迎来到淘居屋商家！',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xFF1B1B1B),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    DefaultTextStyle(
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF464646)),
                        child: Text.rich(
                            TextSpan(text: Constants.ALERT_TIP_HADE, children: [
                          WidgetSpan(
                              child: GestureDetector(
                            onTap: () {
                              RouteHandler.goProtocalPage(context);
                            },
                            child: Text(Constants.ALERT_TIP_BODY,
                                style: TextStyle(color: Color(0xFF388FFF))),
                          )),
                          TextSpan(text: Constants.ALERT_TIP_TAIL)
                        ]))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ZYOutlineButton(
                          '不同意',
                          () {
                            Navigator.of(context).pop();
                            secondConfirm();
                          },
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        ZYRaisedButton(
                          '同意  ',
                          () {
                            Application.sp.setBool('hasAgree', true);
                            Navigator.of(context).pop();

                            // delCart(provider, cartModel?.cartId);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onWillPop: () {
                return Future.value(false);
              });
        });
  }

  void secondConfirm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        '您需要同意后，才能继续使用淘居屋商家的服务',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ZYOutlineButton(
                          '不同意并退出',
                          () {
                            SystemChannels.platform
                                .invokeMethod('SystemNavigator.pop');
                          },
                          horizontalPadding: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ZYRaisedButton(
                          '  同意并使用  ',
                          () {
                            Navigator.of(context).pop();
                            Application.sp.setBool('hasAgree', true);
                            // delCart(provider, cartModel?.cartId);
                          },
                          horizontalPadding: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onWillPop: () {
                return Future.value(false);
              });
        });
  }

  double startX1 = 0.0;
  double startX2 = 0.0;
  BuildContext context1;
  BuildContext context2;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
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
                Builder(
                  builder: (BuildContext ctx) {
                    context1 = ctx;
                    return InkWell(
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
                    );
                  },
                ),
                Builder(builder: (BuildContext ctx) {
                  context2 = ctx;
                  return InkWell(
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
                  );
                }),
              ],
            ),
          ),
          CustomPaint(
            key: ValueKey(_isPwdMode),
            painter: LoginPageIndicatorPainter(
                triangleW: 5.0,
                pointX: _isPwdMode ? startX1 : startX2,
                width: w),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(50)),
            child: Column(
              children: <Widget>[
                TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText: '请输入手机号',
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFFC7C8CB), width: 1)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFFC7C8CB), width: 1)),
                        icon: Container(
                          child: Text('+86'),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFC7C8CB), width: 1))
                              // border: Border.fromBorderSide(BorderSide(color: ))
                              ),
                        ))),
                VSpacing(20),
                _isPwdMode
                    ? TextField(
                        controller: _smsController,
                        decoration: InputDecoration(
                            hintText: '请输入验证码',
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFC7C8CB), width: 1)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFC7C8CB), width: 1)),
                            suffixIcon: SendSmsButton(
                              isActive: false,
                              callback: () {
                                ToastKit.showToast('暂未开通注册');
                              },
                            )))
                    : TextField(
                        obscureText: true,
                        controller: _pwdController,
                        decoration: InputDecoration(
                            hintText: '请输入密码',
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFC7C8CB), width: 1)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFC7C8CB), width: 1)),
                            suffixIcon: FlatButton(
                                onPressed: () {
                                  RouteHandler.goForgetPwdPage(context);
                                },
                                child: Text('忘记密码'))))
              ],
            ),
          ),
          VSpacing(50),
          ZYSubmitButton(
            '登录',
            () {
              // model.login(context);
              loginByPwd(context);
            },
            isActive: canClick,
          ),
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
                      RouteHandler.goProtocalPage(context);
                      // showPrivacy(context);
                    },
                    child: Text('隐私政策与用户协议',
                        style: textTheme.caption
                            .copyWith(color: textTheme.bodyText2.color)),
                  )),
                ])),
          ),
          VSpacing(100),
        ],
      ),
    );
  }
}
