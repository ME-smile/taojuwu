/*
 * @Description:商品binding类的基类，持有商品对象的引用
 * @Author: iamsmiling
 * @Date: 2020-09-27 09:06:52
 * @LastEditTime: 2020-10-19 11:00:13
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/repository/shop/cart_list_model.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';

abstract class BaseGoodsViewModel extends ChangeNotifier {
  int goodsId; // 商品id
  BuildContext context; // 保存对context的引用

  //商品属性列表
  List<ProductSkuAttr> skuList = [];
  ProductBean bean; //商品详情

  //购物车里面的商品数量
  int goodsNumInCart = 0;

  List<RelatedGoodsBean> relatedGoodsList = []; //同料商品

  List<RecommendGoodsBean> recommendGoodsList = []; //为你推荐

  List<SceneProjectBean> sceneProjectList = []; //场景搭配

  List<SoftProjectBean> softProjectList = []; //软装方案

  double get totalPrice;

  int clientId; // 客户id

  StreamSubscription _streamSubscription;

  Future addToCart();

  Future purchase();

  /*
   * @Author: iamsmiling
   * @description: 监听选择客户的事件
   * @param : 
   * @return {type} 
   * @Date: 2020-09-27 15:54:45
   */
  //标示位

  @override
  void addListener(listener) {
    _streamSubscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      clientId = event.mTargetClient.clientId;
      _initCartCount();
    });

    super.addListener(listener);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void refresh() {
    notifyListeners();
  }

  _initCartCount() {
    OTPService.cartCount(context,
            params: {'client_uid': clientId, 'goods_id': bean?.goodsId})
        .then((CartCountResp cartCountResp) {
          goodsNumInCart = CommonKit.parseInt(cartCountResp?.data);
        })
        .catchError((err) => err)
        .whenComplete(refresh);
  }

  like() {
    bean?.isCollect == 0 ? _like() : _dislike();
  }

  //收藏和取消收藏
  _like() {
    OTPService.collect(params: {
      'fav_id': bean?.goodsId,
      'client_uid': clientId,
    })
        .then((ZYResponse response) {
          // ignore: unnecessary_statements
          response?.valid == true ? bean?.isCollect == 1 : '';
        })
        .catchError((err) => err)
        .whenComplete(refresh);
  }

  //取消收藏
  _dislike() {
    OTPService.cancelCollect(params: {
      'fav_id': bean?.goodsId,
      'client_uid': clientId,
    })
        .then((ZYResponse response) {
          // ignore: unnecessary_statements
          response?.valid == true ? bean?.isCollect == 0 : '';
        })
        .catchError((err) => err)
        .whenComplete(refresh);
  }
}
