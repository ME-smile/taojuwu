/*
 * @Description: //T
 * @Author: iamsmiling
 * @Date: 2020-10-26 11:12:05
 * @LastEditTime: 2020-11-10 11:15:59
 */
import 'package:flutter/material.dart';

class SizedInputBox extends StatefulWidget {
  final String hintText;
  final FocusNode focusNode;
  final TextEditingController controller;
  const SizedInputBox(
      {this.hintText = '', this.controller, this.focusNode, Key key})
      : super(key: key);

  @override
  _SizedInputBoxState createState() => _SizedInputBoxState();
}

class _SizedInputBoxState extends State<SizedInputBox> {
  String get hintText => widget.hintText;

  TextEditingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
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
              focusNode: widget.focusNode,
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
