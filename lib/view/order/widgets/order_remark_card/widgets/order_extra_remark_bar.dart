/*
 * @Description: 上门安装意向时间 订单备注
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:26:56
 * @LastEditTime: 2020-10-30 07:56:36
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/view/order/dialog/submit_order_dialog.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

import 'base/order_remark_bar.dart';

class OrderExtratRemarkBar extends StatefulWidget {
  final OrderCreator orderCreator;
  OrderExtratRemarkBar(this.orderCreator, {Key key}) : super(key: key);

  @override
  _OrderExtratRemarkBarState createState() => _OrderExtratRemarkBarState();
}

class _OrderExtratRemarkBarState extends State<OrderExtratRemarkBar> {
  OrderCreator get orderCreator => widget.orderCreator;
  @override
  Widget build(BuildContext context) {
    return OrderRemarkBar(
      title: '备注:',
      text: orderCreator?.extraRemark ?? '请输入备注',
      callback: () =>
          showOrderExtraRemarkDialog(context, orderCreator).whenComplete(() {
        setState(() {});
      }),
    );
  }
}
