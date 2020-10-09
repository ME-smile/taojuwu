/*
 * @Description: 特价标签视图
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-09 16:21:33
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class OnSaleTag extends StatelessWidget {
  final String text;
  final double horizontalPadding;
  final double horizontalMargin;
  final double fontSize;
  const OnSaleTag({
    Key key,
    this.text = '限时特价',
    this.horizontalMargin = 10,
    this.horizontalPadding = 3,
    this.fontSize = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child:
          Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize)),
      decoration: BoxDecoration(color: const Color(0xFFEB8181)),
    );
  }
}

class DummyTag extends StatelessWidget {
  const DummyTag({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(5)),
      child: Text('',
          style: TextStyle(color: Colors.white, fontSize: UIKit.sp(20))),
    );
  }
}
