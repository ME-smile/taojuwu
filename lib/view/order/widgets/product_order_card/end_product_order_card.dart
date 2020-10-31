/*
 * @Description: 提交订单 成品视图
 * @Author: iamsmiling
 * @Date: 2020-10-28 13:36:41
 * @LastEditTime: 2020-10-28 14:27:38
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/end_product/base_end_product_bean.dart';
import 'package:taojuwu/view/order/widgets/product_order_card/common_prodcut_order_card_header.dart';

class EndProductOrderCard extends StatelessWidget {
  final BaseEndProductBean bean;
  const EndProductOrderCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CommonProductOrderCardHeader(bean),
    );
  }
}
