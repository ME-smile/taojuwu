/*
 * @Description: 成品商品的具体实现类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:18:26
 * @LastEditTime: 2020-10-29 13:32:37
 */
import 'package:flutter/cupertino.dart';
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';

import 'base_end_product_bean.dart';

class ConcreteEndProductBean extends BaseEndProductBean {
  ConcreteEndProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);

  @override
  double get totalPrice => 0.0;

  @override
  Future addToCart(BuildContext context) {
    // print(cartArgs);
    showEndProductDetailModalPopup(context, this).whenComplete(() {
      // setState(() {});
    });
    return Future.value(false);
    // throw UnimplementedError();
  }

  @override
  Future buy(BuildContext context) {
    return super.buy(context);

    // throw UnimplementedError();
  }

  @override
  get cartArgs {
    return {
      'sku_id': '$skuId',
      'goods_id': '$goodsId',
      'goods_name': '$goodsName',
      'shop_id': '$shopId',
      'picture': '$picture',
      'num': '$count',
      'estimated_price': totalPrice
    };
  }

  @override
  Map get attrArgs => {};

  @override
  ProductType get productType => ProductType.EndProductType;
}
