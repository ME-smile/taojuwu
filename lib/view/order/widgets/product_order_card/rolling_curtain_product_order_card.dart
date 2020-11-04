/*
 * @Description: 提交订单 卷帘视图
 * @Author: iamsmiling
 * @Date: 2020-10-28 13:38:36
 * @LastEditTime: 2020-11-02 14:17:47
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/rolling_curtain_product_bean.dart';
import 'package:taojuwu/view/order/widgets/product_order_card/common_prodcut_order_card_header.dart';

class RollingCurtainProductOrderCard extends StatelessWidget {
  final RollingCurtainProductBean bean;
  const RollingCurtainProductOrderCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CommonProductOrderCardHeader(bean),
          // CurtainProductAttrsCardView(bean),
        ],
      ),
    );
  }
}
