/*
 * @Description: 窗帘单订单备注
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:37:47
 * @LastEditTime: 2020-10-30 06:58:03
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

import 'widgets/install_time_remark_bar.dart';
import 'widgets/measure_time_remark_bar.dart';
import 'widgets/order_deposit_remark_bar.dart';
import 'widgets/order_extra_remark_bar.dart';

class CurtainOrderRemarkCard extends StatelessWidget {
  final OrderCreator orderCreator;
  const CurtainOrderRemarkCard(this.orderCreator, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          MeasureTimeRemarkBar(orderCreator),
          InstallTimeRemarkBar(orderCreator),
          OrderDepositRemarkBar(orderCreator),
          OrderExtratRemarkBar(orderCreator),
        ],
      ),
    );
  }
}
