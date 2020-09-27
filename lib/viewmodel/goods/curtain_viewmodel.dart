/*
 * @Description: 商品模型
 * @Author: iamsmiling
 * @Date: 2020-09-25 15:57:46
 * @LastEditTime: 2020-09-27 15:48:34
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/viewmodel/goods/binding/price_calculator_binding.dart';

import 'binding/price_calculator_binding.dart';

class CurtainViewModel extends PriceCalculatorBinding {
  final BuildContext mBuildContext;
  final int id;

  bool isLoading = true;

  //购物车里面的商品数量
  int goodsNumInCart = 0;

  // 是否已经收藏过
  bool get hasLiked => bean?.isCollect == 1;

  set hasLiked(bool flag) {
    bean?.isCollect = flag ? 1 : 0;
  }

  CurtainViewModel(this.mBuildContext, this.id) {
    _getCurtainDetail();
  }

  @override
  void addListener(listener) {
    super.addListener(listener);
  }

  Future _getCurtainDetail() {
    return OTPService.productDetail(mBuildContext, params: {'goods_id': id})
        .then((ProductBeanRes response) {
          bean = response?.data?.goodsDetail;
        })
        .catchError((err) => err)
        .whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
  }

  like() {}
}
