/*
 * @Description: 窗帘商品 属性 视图
 * @Author: iamsmiling
 * @Date: 2020-10-28 09:41:14
 * @LastEditTime: 2020-10-28 10:02:16
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';

class BaseCurtainProductAttrGridViewCard extends StatelessWidget {
  final List<ProductSkuAttr> attrList;

  const BaseCurtainProductAttrGridViewCard(this.attrList, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
