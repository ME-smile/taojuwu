/*
 * @Description: 商品模型
 * @Author: iamsmiling
 * @Date: 2020-09-25 15:57:46
 * @LastEditTime: 2020-09-27 17:40:23
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/binding/curtain_price_calculator_binding.dart';

import 'binding/curtain_price_calculator_binding.dart';

class CurtainViewModel extends CurtainPriceCalculatorBinding {
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
