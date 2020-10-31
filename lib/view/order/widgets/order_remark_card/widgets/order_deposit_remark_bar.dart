/*
 * @Description: 上门安装意向时间 订单备注
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:26:56
 * @LastEditTime: 2020-10-30 07:58:07
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/view/order/dialog/submit_order_dialog.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

import 'base/order_remark_bar.dart';

class OrderDepositRemarkBar extends StatefulWidget {
  final OrderCreator orderCreator;
  OrderDepositRemarkBar(this.orderCreator, {Key key}) : super(key: key);

  @override
  _OrderDepositRemarkBarState createState() => _OrderDepositRemarkBarState();
}

class _OrderDepositRemarkBarState extends State<OrderDepositRemarkBar> {
  OrderCreator get orderCreator => widget.orderCreator;
  @override
  Widget build(BuildContext context) {
    return OrderRemarkBar(
      title: '定金:',
      text: orderCreator?.depositAmount ?? '请输入定金',
      callback: () =>
          showDespositRemarkDialog(context, orderCreator).whenComplete(() {
        setState(() {});
      }),
    );
  }
}
