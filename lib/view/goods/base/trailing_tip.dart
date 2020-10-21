/*
 * @Description: 自定义listtile提示
 * @Author: iamsmiling
 * @Date: 2020-10-09 15:50:55
 * @LastEditTime: 2020-10-10 13:30:43
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

class TrailingTip extends StatelessWidget {
  final String text;
  final Function callback;
  const TrailingTip({this.text = '全部', this.callback, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(color: const Color(0xFF999999), fontSize: 12),
          ),
          Icon(
            ZYIcon.next,
            size: 16,
          )
        ],
      ),
    );
  }
}
