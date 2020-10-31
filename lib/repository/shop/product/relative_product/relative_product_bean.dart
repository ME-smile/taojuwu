/*
 * @Description: 相关商品 数据模型  同料商品
 * @Author: iamsmiling
 * @Date: 2020-10-22 16:28:55
 * @LastEditTime: 2020-10-29 09:23:16
 */
import 'package:flutter/cupertino.dart';
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';

class RelativeProductBean extends BaseProductBean {
  RelativeProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  double get totalPrice => 0.0;

  @override
  Future addToCart(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Future buy(BuildContext context) {
    return Future.value(false);
  }

  @override
  Map get attrArgs => throw UnimplementedError();

  @override
  Map<String, dynamic> get cartArgs => throw UnimplementedError();

  @override
  ProductType get productType => throw UnimplementedError();
}
