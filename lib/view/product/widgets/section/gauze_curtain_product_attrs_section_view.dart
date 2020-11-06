/*
 * @Description: 窗纱详情页面属性条
 * @Author: iamsmiling
 * @Date: 2020-10-31 17:31:49
 * @LastEditTime: 2020-10-31 17:33:51
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/attrs/attr_options_bar.dart';

import '../measure_data_tip_bar.dart';

class GauzeCurtainProductAttrsSectionView extends StatelessWidget {
  final BaseCurtainProductDetailBean bean;
  const GauzeCurtainProductAttrsSectionView(this.bean, {Key key})
      : super(key: key);

  List<ProductSkuAttr> get attrList => bean?.attrList;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            MeasureDataTipBar(bean),
            ListBody(
              children: List<Widget>.generate(
                  attrList?.length ?? 0,
                  (index) => AttrOptionsBar(
                        bean,
                        attrList[index],
                        index: index,
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
