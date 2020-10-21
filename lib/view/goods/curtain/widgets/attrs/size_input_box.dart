/*
 * @Description: 输入框  宽 高 离地距离 在测装页面的输入框
 * @Author: iamsmiling
 * @Date: 2020-09-30 15:52:59
 * @LastEditTime: 2020-10-14 14:48:27
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class SizeInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const SizeInputBox(this.controller, {this.hintText = '', Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: 80,
            padding: EdgeInsets.only(right: 16),
            child: Text(
              hintText ?? '',
              style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
            ),
          ),
          Container(
            child: TextField(
              maxLines: 1,
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 3, horizontal: 2),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 80,
            height: 28,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
