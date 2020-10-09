/*
 * @Description: //封装提交订单的按钮
 * @Author: iamsmiling
 * @Date: 2020-10-09 11:00:25
 * @LastEditTime: 2020-10-09 11:07:05
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/viewmodel/order/base/base_order_creator.dart';
import 'package:taojuwu/widgets/zy_future_button.dart';

class SubmitOrderButton extends StatelessWidget {
  final BaseOrderCreator orderCreator;
  const SubmitOrderButton(this.orderCreator, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZYFutureButton(
      horizontalPadding: 20,
      verticalPadding: 8,
      text: '提交订单',
      callback: () {
        return orderCreator.create();
      },
    );
  }
}
