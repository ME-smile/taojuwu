/*
 * @Description: 上门安装意向时间 订单备注
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:26:56
 * @LastEditTime: 2020-10-30 07:29:47
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/view/order/popup_modal/submit_order_popup_modal.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

import 'base/order_remark_bar.dart';

class InstallTimeRemarkBar extends StatefulWidget {
  final OrderCreator orderCreator;
  InstallTimeRemarkBar(this.orderCreator, {Key key}) : super(key: key);

  @override
  _InstallTimeRemarkBarState createState() => _InstallTimeRemarkBarState();
}

class _InstallTimeRemarkBarState extends State<InstallTimeRemarkBar> {
  OrderCreator get orderCreator => widget.orderCreator;
  @override
  Widget build(BuildContext context) {
    return OrderRemarkBar(
      title: '上门安装意向时间:',
      text: orderCreator?.installTime ?? '时间',
      callback: () =>
          showInstallTimePicker(context, orderCreator).whenComplete(() {
        setState(() {});
      }),
    );
  }
}
