/*
 * @Description:商品binding类的基类，持有商品对象的引用
 * @Author: iamsmiling
 * @Date: 2020-09-27 09:06:52
 * @LastEditTime: 2020-09-27 15:51:30
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';

enum CurtainType {
  WindowSunblind, //普通窗帘

  WindowGauzeType, //窗纱

  WindowRollerType //卷帘
}

abstract class BaseGoodsBinding with ChangeNotifier {
  ProductBean bean;

  double totlaPrice;

  int clientId; // 客户id

  StreamSubscription _streamSubscription;

  Future addToFunc() {
    // TODO 加入购物车的逻辑
  } // 加入购物车

  Future purchase() {
    // TODO 购买逻辑
  }

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
