/*
 * @Description: 测量单下单备注视图
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:35:28
 * @LastEditTime: 2020-11-19 13:24:39
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/view/order/widgets/order_remark_card/widgets/install_time_remark_bar.dart';
import 'package:taojuwu/view/order/widgets/order_remark_card/widgets/measure_time_remark_bar.dart';
import 'package:taojuwu/view/order/widgets/order_remark_card/widgets/order_deposit_remark_bar.dart';
import 'package:taojuwu/view/order/widgets/order_remark_card/widgets/order_extra_remark_bar.dart';
import 'package:taojuwu/view/order/widgets/order_remark_card/widgets/window_count_remark_bar.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

class MeasureOrderRemarkCard extends StatelessWidget {
  final OrderCreator orderCreator;
  const MeasureOrderRemarkCard(this.orderCreator, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          MeasureTimeRemarkBar(orderCreator),
          InstallTimeRemarkBar(orderCreator),
          WindowCountRemarkBar(orderCreator),
          OrderDepositRemarkBar(orderCreator),
          OrderExtratRemarkBar(orderCreator),
        ],
      ),
    );
  }
}
