/*
 * @Description: //所有商品的抽象类基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:03:47
 * @LastEditTime: 2020-10-30 15:17:56
 */

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/view/order/submit_order_page.dart';

enum ProductType {
  //布艺帘
  FabricCurtainProductType,
  //卷帘
  RollingCurtainProductType,
  //窗纱
  GauzeCurtainProductType,
  // 成品
  EndProductType,

  // 场景
  SceneDesignProductType,
  // 软装方案
  SoftDesignProductType
}

abstract class AbstractBaseProductBean {
  double get totalPrice;

  Future addToCartAction(BuildContext context) {
    return isClientIdNull ? Future.value(false) : addToCart(context);
  }

  Future buyAction(BuildContext context) {
    return isClientIdNull ? Future.value(false) : buy(context);
  }

  Future addToCart(BuildContext context);

  Future buy(BuildContext context) {
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return SubmitOrderPage(this);
    }));
  }

  Map<dynamic, dynamic> get attrArgs;

  get cartArgs;

  ProductType get productType;

  //是否为设计类产品
  bool get isDesignProduct =>
      productType == ProductType.SceneDesignProductType ||
      productType == ProductType.SoftDesignProductType;

  bool get isClientIdNull {
    if (clientId == null) {
      ToastKit.showInfo('请先选择客户哦');
      return true;
    }
    return false;
  }

  int get clientId => client?.clientId;

  TargetClient client;
}
