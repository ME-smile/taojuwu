/*
 * @Description: 窗帘样式混入
 * @Author: iamsmiling
 * @Date: 2020-10-31 06:31:55
 * @LastEditTime: 2020-10-31 09:32:19
 */
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/view/product/mixin/measure_data_holder.dart';
import 'package:taojuwu/view/product/mixin/product_attr_holder.dart';
import 'package:taojuwu/view/product/mixin/style_selector_holder.dart';

import 'base_product_detail_state.dart';

class BaseCurtainProductDetailState<T> extends BaseProductDetailPageState<T>
    with StyleSelectorHolder, MeasureDataHolder, ProductAttrHolder {
  BaseCurtainProductBean get curtainProductBean =>
      (productBean as BaseCurtainProductBean);

  @override
  void dispose() {
    super.dispose();
  }

  void copyData() {
    roomAttr = curtainProductBean?.roomAttr;
    attrList = curtainProductBean?.attrList;
    measureData = curtainProductBean?.measureData;
    styleSelector = curtainProductBean?.styleSelector;
  }
}
