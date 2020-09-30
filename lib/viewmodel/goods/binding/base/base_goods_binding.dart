/*
 * @Description:商品binding类的基类，持有商品对象的引用
 * @Author: iamsmiling
 * @Date: 2020-09-27 09:06:52
 * @LastEditTime: 2020-09-30 16:52:46
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';

abstract class BaseGoodsBinding extends ChangeNotifier {
  int goodsId; // 商品id
  BuildContext context; // 保存对context的引用

  ProductBean bean;

  double get totalPrice;

  int clientId; // 客户id

  StreamSubscription _streamSubscription;

  Future addToFunc() {
    // TODO 加入购物车的逻辑
  } // 加入购物车

  Future purchase() {
    // TODO 购买逻辑
  }

  /*
   * @Author: iamsmiling
   * @description: 监听选择客户的事件
   * @param : 
   * @return {type} 
   * @Date: 2020-09-27 15:54:45
   */
  @override
  void addListener(listener) {
    _streamSubscription =
        Application.eventBus.on<SelectClientEvent>().listen((event) {
      clientId = event.mTargetClient.clientId;
    });
    super.addListener(listener);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
