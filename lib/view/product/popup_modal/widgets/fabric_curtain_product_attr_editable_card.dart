/*
 * @Description:布艺帘商品商品编辑卡片
 * @Author: iamsmiling
 * @Date: 2020-10-23 14:17:14
 * @LastEditTime: 2020-11-05 14:34:18
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/fabric_curtain_product_detail_bean.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/base_curtain_product_attr_editable_card_header.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';

import 'base_curtain_product_attr_grid_view_card.dart';

class FabricCurtainProductAttrEditableCard extends StatefulWidget {
  final FabricCurtainProductDetailBean bean;
  const FabricCurtainProductAttrEditableCard(this.bean, {Key key})
      : super(key: key);

  @override
  _FabricCurtainProductAttrEditableCardState createState() =>
      _FabricCurtainProductAttrEditableCardState();
}

class _FabricCurtainProductAttrEditableCardState
    extends State<FabricCurtainProductAttrEditableCard> {
  FabricCurtainProductDetailBean get bean => widget.bean;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          BaseCurtainProductAttrEditableCardHeader(
            bean,
            CurtainType.FabricCurtainType,
            setState: setState,
          ),
          BaseCurtainProductAttrGridViewCard(bean, setState),
        ],
      ),
    );
  }
}
