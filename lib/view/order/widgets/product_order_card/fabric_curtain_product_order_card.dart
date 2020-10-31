/*
 * @Description:提交订单 布艺帘卡片视图
 * @Author: iamsmiling
 * @Date: 2020-10-28 13:40:40
 * @LastEditTime: 2020-10-28 14:27:08
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/view/order/widgets/product_order_card/common_prodcut_order_card_header.dart';

class FabricCurtainProductOrderCard extends StatelessWidget {
  final FabricCurtainProductBean bean;
  const FabricCurtainProductOrderCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CommonProductOrderCardHeader(bean),
        ],
      ),
    );
  }
}
