/*
 * @Description: 窗帘商品基类的抽象类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:09:36
 * @LastEditTime: 2020-11-02 09:21:23
 */

import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';

abstract class AbstractCurtainProductBean extends SingleProductBean {
  AbstractCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  double get totalPrice;

  // 过滤工艺
  ///[list]过滤前的工艺列表
  ///返回过滤后的工艺列表
  List<ProductSkuAttrBean> filterCraft(List<ProductSkuAttrBean> list);
}
