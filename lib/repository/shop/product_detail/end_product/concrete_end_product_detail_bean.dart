/*
 * @Description: 成品商品的具体实现类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:18:26
 * @LastEditTime: 2020-12-31 15:48:30
 */
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:taojuwu/repository/base/count_model.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';

import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';

import 'base_end_product_detail_bean.dart';

class ConcreteEndProductDetailBean extends BaseEndProductDetailBean
    implements CountModel {
  ConcreteEndProductDetailBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  double get totalPrice => price * count;

  @override
  Future addToCart(BuildContext context, {Function callback}) {
    // print(cartArgs);

    showEndProductDetailModalPopup(context, this, callback: addToCartRequest)
        .whenComplete(() {
      // setState(() {});
    });
    return Future.value(false);
    // throw UnimplementedError();
  }

  @override
  Future buy(BuildContext context, {Function callback}) {
    return super.buy(context);

    // throw UnimplementedError();
  }

  @override
  get cartArgs {
    return {
      'client_uid': clientId,
      'estimated_price': totalPrice,
      'cart_detail': jsonEncode({
        'sku_id': '$skuId',
        'goods_id': '$goodsId',
        'goods_name': '$goodsName',
        'shop_id': '$shopId',
        'picture': '$picture',
        'num': '$count',
        'estimated_price': totalPrice,
      })
    };
  }

  @override
  Map get attrArgs => {};

  @override
  ProductType get productType => ProductType.EndProductType;
}
