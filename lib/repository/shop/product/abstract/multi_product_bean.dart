/*
 * @Description: 多商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:08:03
 * @LastEditTime: 2020-10-21 15:39:15
 */
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';

import 'base_product_bean.dart';

abstract class MultiProductBean extends BaseProductBean {
  List<SingleProductBean> goodsList;

  MultiProductBean.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
