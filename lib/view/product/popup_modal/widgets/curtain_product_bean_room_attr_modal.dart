/*
 * @Description: 空间选择弹窗
 * @Author: iamsmiling
 * @Date: 2020-10-23 17:39:56
 * @LastEditTime: 2020-10-23 17:48:10
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/option_view.dart';

class CurtainProductDetailBeanRoomAttrModal extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  CurtainProductDetailBeanRoomAttrModal(this.bean, {Key key}) : super(key: key);

  @override
  _CurtainProductDetailBeanRoomAttrModalState createState() =>
      _CurtainProductDetailBeanRoomAttrModalState();
}

class _CurtainProductDetailBeanRoomAttrModalState
    extends State<CurtainProductDetailBeanRoomAttrModal> {
  ProductSkuAttr get skuAttr => widget?.bean?.roomAttr;
  List<ProductSkuAttrBean> get list => widget?.bean?.roomAttr?.data;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Wrap(
          children: List.generate(list.length, (int i) {
            ProductSkuAttrBean bean = list[i];
            return OptionView(
              bean,
              isRoomAttr: true,
              callback: () {
                setState(() {
                  widget.bean.selectAttrBean(skuAttr, i);
                });
              },
            );
          }),
        ),
      ),
    );
  }
}
