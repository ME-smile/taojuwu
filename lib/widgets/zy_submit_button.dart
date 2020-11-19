/*
 * @Description: 提交按钮
 * @Author: iamsmiling
 * @Date: 2020-10-31 13:34:35
 * @LastEditTime: 2020-11-19 16:03:14
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class ZYSubmitButton extends StatelessWidget {
  final String text;
  final Function callback;
  final bool isActive;
  final double horizontalMargin;
  const ZYSubmitButton(this.text, this.callback,
      {Key key, this.isActive: true, this.horizontalMargin = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin, vertical: UIKit.height(20)),
      child: RaisedButton(
        onPressed: isActive ? callback : null,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
          child: Text(
            text ?? '',
            style: Theme.of(context).accentTextTheme.button,
          ),
        ),
      ),
    );
  }
}
