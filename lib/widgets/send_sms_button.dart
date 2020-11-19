/*
 * @Description: 获取验证码按钮
 * @Author: iamsmiling
 * @Date: 2020-08-03 10:46:13
 * @LastEditTime: 2020-11-16 14:36:37
 */
import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'zy_outline_button.dart';

typedef FutureCallback = Future Function();

class SendSmsButton extends StatefulWidget {
  final FutureCallback callback;
  final FutureCallback validateSms;
  final bool isActive;
  final TextEditingController telPhoneController;
  final bool hasSend;
  SendSmsButton(
      {Key key,
      this.callback,
      this.isActive: true,
      this.telPhoneController,
      this.validateSms,
      this.hasSend = false})
      : super(key: key);

  @override
  _SendSmsButtonState createState() => _SendSmsButtonState();
}

class _SendSmsButtonState extends State<SendSmsButton> {
  ValueNotifier<int> countDown;
  ValueNotifier<bool> hasSend;
  ValueNotifier<bool> isValidTel;
  @override
  void initState() {
    super.initState();
    hasSend = ValueNotifier<bool>(widget.hasSend);

    countDown = ValueNotifier<int>(120);
    isValidTel = ValueNotifier<bool>(validateTel());
    widget.telPhoneController.addListener(switchButtonDisabledStatus);
  }

  Timer timer;

  bool validateTel() =>
      RegexUtil.isMobileExact(widget.telPhoneController?.text);

  void switchButtonDisabledStatus() {
    isValidTel.value = validateTel();
  }

  @override
  void dispose() {
    super.dispose();
    hasSend?.dispose();
    countDown?.dispose();
    timer?.cancel();
    //force to close stream
  }

  Future onTap() async {
    widget.callback().then((_) {
      hasSend.value = true;
      startCount();
    }).catchError((_) {
      hasSend.value = false;
    });
  }

  void startCount() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (countDown.value <= 0) {
        hasSend.value = false;
        countDown.value = 120;
        timer?.cancel();
        return;
      }
      countDown.value--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = Theme.of(context);
    // TextTheme accentTextTheme = themeData.accentTextTheme;
    return ValueListenableBuilder(
        valueListenable: hasSend,
        builder: (BuildContext context, bool _hasSend, _) {
          return _hasSend == false
              ? ValueListenableBuilder(
                  valueListenable: isValidTel,
                  builder: (BuildContext context, bool isValid, _) {
                    return ZYRaisedButton(
                      '获取验证码',
                      onTap,
                      horizontalPadding: 12,
                      verticalPadding: 8,
                      isActive: isValid ?? false,
                    );
                  },
                )

              // RaisedButton(
              //     padding: EdgeInsets.all(0),
              //     child: Text(
              //       '获取验证码',
              //       style: accentTextTheme.button,
              //     ),
              //     onPressed: widget.isActive
              //         ? () {
              //             // hasSend?.value = true;
              //             // timer = Timer.periodic(const Duration(seconds: 1),
              //             //     (Timer timer) {
              //             //   if (countDown.value <= 0) {
              //             //     hasSend?.value = false;
              //             //     countDown.value = 120;
              //             //   } else {
              //             //     countDown.value--;
              //             //   }
              //             // });
              //             widget.callback();
              //           }
              //         : null,
              //   )
              : ValueListenableBuilder(
                  valueListenable: countDown,
                  builder: (BuildContext context, int secs, _) {
                    return ZYOutlineButton(
                      '${secs}s后重新发送',
                      null,
                      isActive: false,
                      horizontalPadding: 8,
                      verticalPadding: 8,
                    );
                  });
        });
  }
}
