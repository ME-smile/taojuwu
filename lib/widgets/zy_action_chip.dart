/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-10-31 13:34:35
 * @LastEditTime: 2020-11-18 14:59:30
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/triangle_clipper.dart';

class ZYActionChip extends StatefulWidget {
  final ActionBean bean;
  final Function callback;
  final bool showNumber;
  ZYActionChip({Key key, this.bean, this.callback, this.showNumber = false})
      : super(key: key);

  @override
  _ZYActionChipState createState() => _ZYActionChipState();
}

class _ZYActionChipState extends State<ZYActionChip> {
  ActionBean get bean => widget.bean;
  Function get callback => widget.callback;
  bool get isChecked => bean.isChecked;
  bool get showNumber => widget.showNumber;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Stack(
        children: <Widget>[
          Container(
              height: 28,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    constraints: BoxConstraints(minWidth: 80),
                    child: Text(
                      '${bean?.text}${showNumber ? "(${bean?.count})" : ""}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: isChecked == true
                              ? Colors.black
                              : Color(0xFF333333)),
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        border: Border.all(
                            width: 1,
                            color:
                                isChecked ? Colors.black : Color(0xFFCBCBCB))),
                  )
                ],
              )),
          Positioned(
            child: isChecked ? TriAngle() : Container(),
            bottom: 0,
            right: 0,
          )
        ],
      ),
    );
  }
}

class ActionBean {
  String text;
  bool isChecked;
  int count;
  ActionBean({this.isChecked, this.text});
  ActionBean.fromJson(Map<String, dynamic> json) {
    this.text = json['text'];
    this.isChecked = json['is_checked'];
    this.count = json['count'];
  }
}
