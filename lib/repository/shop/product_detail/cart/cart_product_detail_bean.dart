/*
 * @Description: 购物车
 * @Author: iamsmiling
 * @Date: 2020-11-05 14:25:41
 * @LastEditTime: 2020-11-05 17:51:04
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/multi_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';

class CartProductDetailBean extends MultiProductDetailBean {
  @override
  Future addToCart(BuildContext context, {Function callback}) {
    return Future.value(false);
  }

  @override
  Map get attrArgs => null;

  @override
  get cartArgs => null;

  @override
  ProductType get productType => ProductType.CartProductType;

  @override
  double get totalPrice =>
      goodsList
          ?.where((e) => e?.isChecked)
          ?.toList()
          ?.map((e) => e?.totalPrice ?? 0.0)
          ?.reduce((a, b) => a + b) ??
      0.0;
  CartProductDetailBean(List<SingleProductDetailBean> list) {
    goodsList = list;
  }
}
