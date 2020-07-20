import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'zy_outline_button.dart';

class SendSmsButton extends StatefulWidget {
  final Function callback;
  final bool isActive;
  SendSmsButton({Key key, this.callback, this.isActive: true})
      : super(key: key);

  @override
  _SendSmsButtonState createState() => _SendSmsButtonState();
}

class _SendSmsButtonState extends State<SendSmsButton> {
  ValueNotifier<int> countDown;
  ValueNotifier<bool> hasSend;
  @override
  void initState() {
    super.initState();
    hasSend = ValueNotifier<bool>(false);
    countDown = ValueNotifier<int>(120);
  }

  Timer timer;

  @override
  void dispose() {
    super.dispose();
    hasSend?.dispose();
    countDown?.dispose();
    timer?.cancel();
    //force to close stream
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = Theme.of(context);
    // TextTheme accentTextTheme = themeData.accentTextTheme;
    return ValueListenableBuilder(
        valueListenable: hasSend,
        builder: (BuildContext context, bool _hasSend, _) {
          return _hasSend == false
              ? ZYRaisedButton(
                  '获取验证码',
                  widget.callback,
                  horizontalPadding: 4,
                  isActive: widget.isActive ?? false,
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
                      horizontalPadding: 4,
                    );
                  });
        });
  }
}
