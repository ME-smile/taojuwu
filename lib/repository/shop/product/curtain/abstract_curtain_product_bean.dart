/*
 * @Description: 窗帘商品基类的抽象类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:09:36
 * @LastEditTime: 2020-10-21 15:45:56
 */

import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';

abstract class AbstractCurtainProductBean extends SingleProductBean {
  AbstractCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  double get totalPrice;
}
