/*
 * @Description: 朴素按钮
 * @Author: iamsmiling
 * @Date: 2020-10-09 17:02:09
 * @LastEditTime: 2020-10-09 17:06:05
 */
import 'package:flutter/material.dart';

class ZYPlainButton extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Function callback;
  const ZYPlainButton(this.text,
      {this.style =
          const TextStyle(color: const Color(0xFFFF6161), fontSize: 14),
      this.callback,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
