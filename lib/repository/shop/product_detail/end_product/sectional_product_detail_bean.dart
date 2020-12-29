/*
 * @Description: SectionalProductDetailBean
 * @Author: iamsmiling
 * @Date: 2020-12-28 11:01:39
 * @LastEditTime: 2020-12-29 16:18:43
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';

import 'base_end_product_detail_bean.dart';

class SectionalProductDetailBean extends BaseEndProductDetailBean {
  SectionalProductDetailBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    width = 1.0;
  }

  @override
  Map get attrArgs => {};

  @override
  get cartArgs => {
        'client_uid': clientId,
        'estimated_price': totalPrice,
        'cart_detail': jsonEncode({
          'sku_id': '$defalutSkuId',
          'goods_id': '$goodsId',
          'goods_name': '$goodsName',
          'shop_id': '$shopId',
          'picture': '$picture',
          'num': '$count',
          'length': '$width',
          'estimated_price': totalPrice,
        })
      };

  @override
  ProductType get productType => ProductType.SectionalProductType;

  @override
  double get totalPrice => price * width;

  @override
  Future addToCart(BuildContext context, {Function callback}) {
    // print(cartArgs);
    showSectionalbarProductDetailModalPopup(context, this,
            callback: addToCartRequest)
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

  String get widthMStr =>
      (CommonKit.isNumNullOrZero(width) ? 0 : width).toStringAsFixed(1);

  String get selectedOptionsName =>
      CommonKit.isNumNullOrZero(width) ? '' : "宽:$widthMStr";

  String get selectedAttrName => selectedOptionsName;

  String get detailDescription => "米数:$widthMStr米";
}
