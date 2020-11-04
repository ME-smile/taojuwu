/*
 * @Description: 软装方案 场景设计商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:22:16
 * @LastEditTime: 2020-11-03 15:49:32
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/add_to_cart_event.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/curtain/rolling_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/abstract_base_design_product_bean.dart';
import 'package:taojuwu/repository/shop/product/end_product/concrete_end_product_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';

abstract class BaseDesignProductBean extends AbstractDesignProductBean {
  BaseDesignProductBean.fromJson(Map<String, dynamic> json) {
    id = json['scenes_id'];
    name = json['name'];
    designName = json['scenes_name'];
    picture = json['image'];
    room = json['space'];
    style = json['style'];
    desc = json['scenes_detail'];
    picId = json['pic_id'];
    goodsList = CommonKit.parseList(json['goods_list'])?.map((e) {
      int type = e['goods_type'];
      return type == 0
          ? ConcreteEndProductBean.fromJson(e)
          : type == 1
              ? FabricCurtainProductBean.fromJson(e)
              : RollingCurtainProductBean.fromJson(e);
      // if (e['goods_type'] == 0) {}
    })?.toList();
    totalPrice = CommonKit.parseDouble(json['total_price']);
  }

  @override
  double get marketPrice {
    double tmp = 0.0;
    if (!CommonKit.isNullOrEmpty(goodsList)) {
      goodsList?.forEach((element) {
        tmp += element?.marketPrice;
      });
      return tmp;
    }
    return tmp;
  }

  @override
  Future addToCart(BuildContext context, {Function callback}) {
    print('软装方案加入购物车');

    // Map<String, dynamic> params = {'client_uid': 395, 'cart_list': "$cartArgs"};
    // print(params);
    // OTPService.addCartList(params).then((ZYResponse response) {
    //   if (response?.valid == true) {
    //     print('加入购物车成功');
    //   }
    // }).whenComplete(() {});

    return _addToCartRequest();
  }

  Future _addToCartRequest() {
    // LogUtil.e({'client_uid': clientId, 'cart_list': jsonEncode(cartArgs)});
    // print({'client_uid': clientId, 'cart_list': cartArgs});
    // LogUtil.e({'client_uid': clientId, 'cart_list': cartArgs});

    return OTPService.addCartList(
            {'client_uid': clientId, 'cart_list': jsonEncode(cartArgs)})
        .then((ZYResponse response) {
      if (response?.valid == true) {
        ToastKit.showInfo(response?.message);
        Application.eventBus.fire(AddToCartEvent(response?.data));
      }
      // ToastKit.showInfo(response?.data);

      // ToastKit.showInfo(response?.message);
    }).catchError((err) => err);
  }

  @override
  Future buy(BuildContext context, {Function callback}) {
    _getMeasureIds(context).then((_) {
      super.buy(context);
    }).catchError((err) {
      ToastKit.showErrorInfo('网络请求失败,请重试');
    });
    return super.buy(context);
  }

  Future _getMeasureIds(BuildContext context) async {
    goodsList?.forEach((e) {
      if (e is BaseCurtainProductBean) {
        return OTPService.saveMeasure(context, params: e.mesaureDataArg)
            .then((ZYResponse response) {
          if (response?.valid == true) {
            e.measureData?.id = int.parse(response?.data);
          }
        }).catchError((err) {
          return false;
        });
      }
    });
  }

  @override
  Map get attrArgs => throw UnimplementedError();

  @override
  get cartArgs =>
      goodsList
          ?.map((e) => {
                'cart_tag': 'app',
                'cart_detail': jsonEncode({
                  'goods_name': e?.goodsName,
                  'sku_id': e?.skuId,
                  'price': e?.price,
                  'num': e?.count,
                  'sku_name': e?.skuName ?? '',
                  'goods_id': e?.goodsId,
                  'picture': e?.picId
                }),
                'estimated_price': e?.totalPrice,
                'wc_attr': jsonEncode(e?.attrArgs),
                'measure_data':
                    e is BaseCurtainProductBean ? e?.mesaureDataArg : 0
              })
          ?.toList() ??
      [];
}
