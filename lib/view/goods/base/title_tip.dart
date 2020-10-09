/*
 * @Description: 标题文字封装
 * @Author: iamsmiling
 * @Date: 2020-10-09 11:21:46
 * @LastEditTime: 2020-10-09 13:36:11
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/common_kit.dart';

class TitleTip extends StatelessWidget {
  final String title;
  final String subTitle;
  final Alignment alignment;
  const TitleTip(
      {Key key,
      this.title = '',
      this.alignment = Alignment.centerLeft,
      this.subTitle = ''})
      : super(key: key);

  bool get showSubTitle => !CommonKit.isNullOrEmpty(subTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text.rich(TextSpan(
          text: title,
          style: TextStyle(
              color: const Color(0xFF1B1B1B),
              fontSize: 14,
              fontWeight: FontWeight.bold),
          children: [
            WidgetSpan(
                child: Visibility(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  subTitle,
                  style: TextStyle(
                      color: const Color(0xFF999999),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              visible: showSubTitle,
            ))
          ])),
    );
  }
}
