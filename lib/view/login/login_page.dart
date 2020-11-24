import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/login/login_viewmodel.dart';
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
  UserProvider _userProvider;
  ValueNotifier<bool> showClearIcon;
  @override
  void initState() {
    super.initState();
    showClearIcon = ValueNotifier<bool>(false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    initView();
  }

  @override
  void dispose() {
    showClearIcon?.dispose();
    super.dispose();
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

  void afterLogin(Map<String, dynamic> json) {
    _userProvider.userInfo.saveUserInfo(json);
  }

  bool canClick = true;

  Future sendSms(LoginViewModel model) {
    String tel = model?.phoneController?.text;
    String errMsg;
    return OTPService.sendSms(params: {'mobile': tel, 'type': 2})
        .then((ZYResponse response) {
      if (response?.valid == true) {
        model?.hasSendSms = true;
      } else {
        model?.hasSendSms = false;
        errMsg = response?.message ?? '';
        ToastKit.showInfo(errMsg);
        throw Exception('发送验证码失败');
      }
    }).catchError((err) {
      model?.hasSendSms = false;
      ToastKit.showInfo(err);
      throw Exception('发送验证码失败');
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomPadding: false,
      body: ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: Builder(
          builder: (BuildContext ctx) {
            LoginViewModel model = ctx.watch<LoginViewModel>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 120, bottom: 36),
                  child: Text(
                    '欢迎来到淘居屋',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                  ),
                ),

                // Text(
                //   '登陆后可购买商品或者查看更多内容',
                //   style: textTheme.subtitle2.copyWith(
                //     fontSize: UIKit.sp(28),
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // VSpacing(60),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UIKit.width(70), vertical: UIKit.height(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Builder(builder: (BuildContext ctx) {
                        context1 = ctx;
                        return InkWell(
                          child: Text(
                            '手机号码登录',
                            style: model?.isPwdMode == true
                                ? TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF333333))
                                : textTheme.subtitle2,
                          ),
                          onTap: () => model.changeLoginMode(0),
                        );
                      }),
                      Builder(builder: (BuildContext ctx) {
                        context2 = ctx;
                        return InkWell(
                          child: Text(
                            '密码登录',
                            style: !model.isPwdMode == true
                                ? TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF333333))
                                : textTheme.subtitle2,
                          ),
                          onTap: () => model.changeLoginMode(1),
                        );
                      }),
                    ],
                  ),
                ),
                Selector(
                  builder: (BuildContext context, bool isPwdMode, _) {
                    return CustomPaint(
                      key: ValueKey(isPwdMode),
                      painter: LoginPageIndicatorPainter(
                          triangleW: 5.0,
                          pointX: isPwdMode ? startX1 : startX2,
                          width: w),
                    );
                  },
                  selector: (BuildContext context, LoginViewModel model) {
                    return model.isPwdMode;
                  },
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.symmetric(horizontal: UIKit.width(50)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: model.phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) {
                            showClearIcon.value = true;
                          },
                          onEditingComplete: () {
                            showClearIcon.value = false;
                          },
                          decoration: InputDecoration(
                              hintText: '请输入手机号',
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  ZYIcon.clear,
                                  size: 16,
                                ),
                                onTap: () {
                                  model?.phoneController?.text = '';
                                },
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFC7C8CB), width: .5)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFC7C8CB), width: .5)),
                              icon: Container(
                                child: Text('+86'),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFFC7C8CB),
                                            width: .5))
                                    // border: Border.fromBorderSide(BorderSide(color: ))
                                    ),
                              )),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 16),
                          child: IndexedStack(
                            index: model.isPwdMode ? 0 : 1,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  TextField(
                                      maxLines: 1,
                                      controller: model.smsController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '请输入验证码',

                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFC7C8CB),
                                                width: 1)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFC7C8CB),
                                                width: 1)),
                                        // suffixIcon: ),
                                      )),
                                  Positioned(
                                    right: 0,
                                    bottom: -4,
                                    // bottom: 1,
                                    child: SendSmsButton(
                                        telPhoneController:
                                            model.phoneController,
                                        isActive: model.isValidTel,
                                        callback: () => sendSms(model)),
                                  )
                                ],
                              ),
                              TextField(
                                obscureText: true,
                                controller: model.pwdController,
                                decoration: InputDecoration(
                                    hintText: '请输入密码',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFC7C8CB),
                                            width: .5)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFC7C8CB),
                                            width: .5)),
                                    suffixIcon: FlatButton(
                                        onPressed: () {
                                          RouteHandler.goForgetPwdPage(context);
                                        },
                                        child: Text('忘记密码'))),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: ZYSubmitButton(
                    '登录',
                    () {
                      model.login(context);
                      // loginByPwd(context);
                    },
                    isActive: true,
                  ),
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
            );
          },
        ),
      ),
    );
  }
}
