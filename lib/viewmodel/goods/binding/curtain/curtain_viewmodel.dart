/*
 * @Description: 商品模型
 * @Author: iamsmiling
 * @Date: 2020-09-25 15:57:46
 * @LastEditTime: 2020-10-09 13:55:28
 */
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/curtain_sku_attr.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/binding/curtain_price_calculator_binding.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/binding/curtain_style_selector_binding.dart';

import 'binding/curtain_price_calculator_binding.dart';

class CurtainViewModel extends CurtainPriceCalculatorBinding
    with CurtainStyleSelectorBinding {
  final BuildContext mBuildContext;
  final int id;

  List<RelatedGoodsBean> relatedGoodsList; //同料商品

  List<SoftProjectBean> softProjectList; // 软装方案

  bool isLoading = true;

  //购物车里面的商品数量
  int goodsNumInCart = 0;

  // 是否已经收藏过
  bool get hasLiked => bean?.isCollect == 1;

  set hasLiked(bool flag) {
    bean?.isCollect = flag ? 1 : 0;
  }

  CurtainViewModel(this.mBuildContext, this.id) : super() {
    _fetchData();
  }

  void _fetchData() {
    // _initCurtainSkuAttr();
    _getCurtainDetail();
  }

  Future _initCurtainSkuAttr() {
    return rootBundle
        .loadString('assets/data/curtain.json')
        .then((String data) {
      Map json = jsonDecode(data);
      curtainSkuAttr = CurtainSkuAttr.fromJson(json);
    }).catchError((err) {
      return err;
    });
  }

  Future _getCurtainDetail() async {
    await OTPService.productDetail(mBuildContext, params: {'goods_id': id})
        .then((ProductBeanRes response) {
          bean = response?.data?.goodsDetail;
          relatedGoodsList = response?.data?.relatedGoodsList;
          softProjectList = response?.data?.softProjectList;
        })
        .catchError((err) => err)
        .whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
    isLoading = false;
    notifyListeners();
  }

  like() {}

  void refresh() {
    notifyListeners();
  }
}
