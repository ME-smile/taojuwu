/*
 * @Description: 软装方案 场景设计商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:22:16
 * @LastEditTime: 2020-11-13 09:36:35
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/add_to_cart_event.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/fabric_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/rolling_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/abstract_base_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/concrete_end_product_detail_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';

abstract class BaseDesignProductDetailBean
    extends AbstractDesignProductDetailBean {
  BaseDesignProductDetailBean.fromJson(Map<String, dynamic> json) {
    id = json['scenes_id'];
    name = json['name'];
    designName = json['scenes_name'];
    picture = json['image'];
    bigPicture = json['image_big'];
    room = json['space'];
    style = json['style'];
    desc = json['scenes_detail'];
    picId = json['pic_id'];
    goodsList = CommonKit.parseList(json['goods_list'])?.map((e) {
      int type = e['goods_type'];
      return type == 0
          ? ConcreteEndProductDetailBean.fromJson(e)
          : type == 1
              ? FabricCurtainProductDetailBean.fromJson(e)
              : RollingCurtainProductDetailBean.fromJson(e);
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
    print({'client_uid': clientId, 'cart_list': cartArgs});
    return OTPService.addCartList(
            {'client_uid': clientId, 'cart_list': jsonEncode(cartArgs)})
        .then((ZYResponse response) {
      if (response?.valid == true) {
        ToastKit.showInfo(response?.message);
        Application.eventBus.fire(AddToCartEvent(response?.data));
      } else {}

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
      if (e is BaseCurtainProductDetailBean) {
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
                    e is BaseCurtainProductDetailBean ? e?.mesaureDataArg : 0
              })
          ?.toList() ??
      [];
  //使用默认宽高窗帘的个数
  int get useDefaultSizeCurtainCount {
    int count = 0;
    for (int i = 0; i < goodsList?.length; i++) {
      SingleProductDetailBean e = goodsList[i];
      if (e is BaseCurtainProductDetailBean && e?.isUseDefaultSize == true) {
        count++;
      }
    }
    return count;
  }
}
