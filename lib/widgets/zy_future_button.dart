/*
 * @Description: //futurebutton 封装 传入一个future
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-09 10:58:53
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

typedef Callback = Future Function();

enum ButtonState {
  isActive,
  isLoading,
  isDisabled,
}

class ZYFutureButton extends StatefulWidget {
  final String text;
  final Callback callback;
  final bool isActive;

  final double horizontalPadding;
  final double verticalPadding;
  final double fontsize;
  ZYFutureButton(
      {Key key,
      this.text,
      this.callback,
      this.isActive,
      this.horizontalPadding = 28,
      this.verticalPadding = 5,
      this.fontsize = 13})
      : super(key: key);

  @override
  _ZYFutureButtonState createState() => _ZYFutureButtonState();
}

class _ZYFutureButtonState extends State<ZYFutureButton> {
  Callback get callback => widget.callback;
  String get text => widget.text;
  double get fontsize => widget.fontsize;
  double get horizontalPadding => widget.horizontalPadding;
  double get verticalPadding => widget.verticalPadding;
  ButtonState mButtonState = ButtonState.isActive;
  bool get isActive => mButtonState == ButtonState.isActive;
  bool get isLoading => mButtonState == ButtonState.isLoading;
  void onTap() {
    setState(() {
      mButtonState = ButtonState.isLoading;
    });
    callback().whenComplete(() {
      setState(() {
        mButtonState = ButtonState.isActive;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        child: isLoading
            ? CupertinoActivityIndicator()
            : Text(
                text,
                style: accentTextTheme.button.copyWith(fontSize: fontsize),
                textAlign: TextAlign.center,
              ),
        decoration: BoxDecoration(
            color: isActive ? themeData.accentColor : themeData.disabledColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              width: 1,
              color: isActive ? themeData.accentColor : themeData.disabledColor,
            )),
        margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
      ),
    );
  }
}
