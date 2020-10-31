/*
 * @Description: 卷帘商品
 * @Author: iamsmiling
 * @Date: 2020-10-27 18:09:53
 * @LastEditTime: 2020-10-28 10:08:49
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/rolling_curtain_product_bean.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';

import 'base_curtain_product_attr_editable_card_header.dart';

class RollingCurtainProductAttrEditableCard extends StatefulWidget {
  final RollingCurtainProductBean bean;
  RollingCurtainProductAttrEditableCard(this.bean, {Key key}) : super(key: key);

  @override
  _RollingCurtainProductAttrEditableCardState createState() =>
      _RollingCurtainProductAttrEditableCardState();
}

class _RollingCurtainProductAttrEditableCardState
    extends State<RollingCurtainProductAttrEditableCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BaseCurtainProductAttrEditableCardHeader(
        widget.bean,
        CurtainType.RollingCurtainType,
        setState: setState,
      ),
    );
  }
}
