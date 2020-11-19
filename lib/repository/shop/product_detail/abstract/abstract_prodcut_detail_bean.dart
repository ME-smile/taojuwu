/*
 * @Description: 商品的抽象类
 * @Author: iamsmiling
 * @Date: 2020-11-05 09:34:22
 * @LastEditTime: 2020-11-19 09:24:34
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/view/order/submit_order_page.dart';

import 'abstract_base_product_detail_bean.dart';

abstract class AbstractProductDetailBean extends AbstractBaseProductDetailBean {
  double get totalPrice;

  Future addToCartAction(BuildContext context, {Function callback}) {
    return isClientIdNull(context)
        ? Future.value(false)
        : addToCart(context, callback: callback);
  }

  Future buyAction(BuildContext context, {Function callback}) {
    return isClientIdNull(context)
        ? Future.value(false)
        : buy(context, callback: callback);
  }

  Future addToCart(BuildContext context, {Function callback}) {
    return Future.value();
  }

  Future buy(BuildContext context, {Function callback}) {
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

  bool isClientIdNull(BuildContext context) {
    if (clientId == null) {
      ToastKit.showInfo('请先添加客户哦');
      RouteHandler.goCustomerEditPage(context, title: '添加客户');
      return true;
    }
    return false;
  }

  int get clientId => client?.clientId;

  TargetClient client;
}
