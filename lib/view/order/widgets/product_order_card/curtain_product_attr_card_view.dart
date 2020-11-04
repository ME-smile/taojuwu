/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-11-02 13:39:02
 * @LastEditTime: 2020-11-02 14:20:16
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';

class CurtainProductAttrsCardView extends StatelessWidget {
  final BaseCurtainProductBean bean;
  const CurtainProductAttrsCardView(this.bean, {Key key}) : super(key: key);

  List<ProductSkuAttr> get attrList => bean?.attrList;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F9),
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 8),
        itemBuilder: (BuildContext context, int index) {
          ProductSkuAttr item = attrList[index];
          return Text(
            '${item?.name ?? ''}:${item?.selectedAttrName ?? ''}',
            style: TaojuwuTextStyle.GREY_TEXT_STYLE,
          );
        },
        itemCount: attrList?.length ?? 0,
      ),
    );
  }
}
