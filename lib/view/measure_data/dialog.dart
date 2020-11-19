/*
 * @Description: 修改
 * @Author: iamsmiling
 * @Date: 2020-11-19 10:07:22
 * @LastEditTime: 2020-11-19 10:15:27
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

Future modifyDeltaY(BuildContext context, OrderGoodsMeasureData measureData) {
  String tmp;
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '离地距离',
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(fontSize: 16, color: Color(0xFF333333)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 36,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: TextField(
                      onChanged: (String text) {
                        tmp = text;
                      },
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: '请输入离地距离（cm）',
                          fillColor: const Color(0xFFF2F2F2),
                          contentPadding: EdgeInsets.all(10)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ZYOutlineButton('取消', () {
                      Navigator.of(context).pop();
                    }),
                    SizedBox(
                      width: 40,
                    ),
                    ZYRaisedButton('确定', () {
                      // saveSize(goodsProvider);
                      measureData?.newVerticalGroundHeight = tmp;

                      Navigator.of(context).pop();
                    })
                  ],
                )
              ],
            ),
          );
        });
  } else {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text('离地距离(cm)'),
              content: Column(
                children: <Widget>[
                  CupertinoTextField(
                    placeholder: '请输入离地距离(cm)',
                    keyboardType: TextInputType.number,
                    onChanged: (String text) {
                      tmp = text;
                    },
                    autofocus: true,
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    measureData?.newVerticalGroundHeight = tmp;

                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }
}
