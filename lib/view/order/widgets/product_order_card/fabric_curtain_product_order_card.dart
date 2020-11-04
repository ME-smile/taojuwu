/*
 * @Description:提交订单 布艺帘卡片视图
 * @Author: iamsmiling
 * @Date: 2020-10-28 13:40:40
 * @LastEditTime: 2020-11-02 13:47:18
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/order/widgets/product_order_card/common_prodcut_order_card_header.dart';

import 'curtain_product_attr_card_view.dart';

class FabricCurtainProductOrderCard extends StatelessWidget {
  final BaseCurtainProductBean bean;
  const FabricCurtainProductOrderCard(this.bean, {Key key}) : super(key: key);

  List<ProductSkuAttr> get attrList => bean?.attrList;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CommonProductOrderCardHeader(bean),
          CurtainProductAttrsCardView(bean),
        ],
      ),
    );
  }
}
